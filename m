Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:39134 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934681Ab0BZAUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 19:20:44 -0500
Message-ID: <4B8713DA.1010908@yahoo.com>
Date: Fri, 26 Feb 2010 01:20:42 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: John Linville <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2x00 : hw support txdone implementation.
References: <4B86CCC3.80403@yahoo.com> <1267131600.16176.47.camel@mj>
In-Reply-To: <1267131600.16176.47.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/02/2010 22:00, Pavel Roskin wrote:
> On Thu, 2010-02-25 at 20:17 +0100, Alban Browaeys wrote:
>    
>> This is an implementation that support WCID being the key_index coming
>> from benoit without the change in the meaning of the tx fallback flag.
>>      
> This text is hard to understand without context.  Please use a
> description for the changes contained in the patch, not for the
> circumstances around it.  The same applies to the subject.  A space
> before ":" is unnecessary.
>
>    
Fixing it.

>> It replaces the software only implementation by an implementation
>> supporting HW encryption.
>>      
> So, I guess rt2800pci_txdone() would not work correctly if hardware
> encryption is used?  Perhaps that should be explained.
>
>    
Explain that HW encryption is not working with current code ? Well it 
cannot work at all . At least txdone
read WCID (WIRLESS_CLI_ID as written in rt2800pci_write_tx_desc as the 
key index:
rt2x00_set_field32(&word, TXWI_W1_WIRELESS_CLI_ID,
                            test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags) ?
                            txdesc->key_idx : 0xff);

then in rt2800pci_txdone we read it as the queue entry index:
index = rt2x00_get_field32(reg, TX_STA_FIFO_WCID) - 1;


As Josef also found out this leads to a mess:
"that doesn't even work most of the time.  I seperated out all of the 
TX_STA_FIFO
reading stuff and either TX_STA_FIFO_VALID would be 0,
TX_STA_FIFO_TX_ACK_REQUIRED would be 0, or TX_STA_FIFO_WCID would be 
254, which
is way higher than the queue limit.  So basically it gives us crap 
statistics."
http://article.gmane.org/gmane.linux.kernel.wireless.general/46713

>> It fixes the mixes of usage of WCID behing set to the key_idx and
>> then getting used as the entry index in the queue.
>>      
> Maybe WCID could be expanded at least once?  "behing" must be a typo.
>
>    

WCID is TX_STA_FIFO_WCID in the code. Do you mean I should use 
TX_STA_FIFO_WCID in the comment ?
Or WIRELESS_CLI_ID as to what it means (and the constant used in 
write_tx_desc). Both are the same
one is used for writing it , the other for reading it. Out of knowing 
which one to use in the comment I used WCID.


>>    	/*
>> -	 * During each loop we will compare the freshly read
>> -	 * TX_STA_FIFO register value with the value read from
>> -	 * the previous loop. If the 2 values are equal then
>> -	 * we should stop processing because the chance it
>> -	 * quite big that the device has been unplugged and
>> -	 * we risk going into an endless loop.
>> +	 * To avoid an endlees loop, we only read the TX_STA_FIFO register up
>> +	 * to 256 times (this is enought to get all values from the FIFO). In
>> +	 * normal situation, the loop is terminated when we reach a value with
>> +	 * TX_STA_FIFO_VALID bit is 0.
>>      
> Please spell check your comments.
>
> I think using a different way for terminating the loop is a completely
> separate issue not related to the hardware crypto support.  It should be
> explained why the old code needs to be changed.
>
>    
>>    		/*
>>    		 * Skip this entry when it contains an invalid
>>    		 * queue identication number.
>>    		 */
>> -		type = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
>> -		if (type>= QID_RX)
>> +		if (pid<  1)
>>    			continue;
>>      
> I'm concerned that you are killing a valid check here.  pid should be
> between 1 and QID_RX (inclusively).
>
> It looks like you are replacing the existing code with your code instead
> of improving it with a new check.  That alone could be a reason to
> reject your patch.
>
>    
Thank you I did not noticed that (the check was pid < 1 back when the 
patch was made. This rewrite of the check is more
of a merge artifact.
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2009-August/000210.html

>> -			/*
>> -			 * Catch up.
>> -			 * Just report any entries we missed as failed.
>> -			 */
>> -			WARNING(rt2x00dev,
>> -				"TX status report missed for entry %d\n",
>> -				entry_done->entry_idx);
>>      
> I'm concerned that you are removing this check.  Is this condition
> impossible now or we just cannot detect it anymore?
>
>    

Both.

>> -		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
>> -		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
>> +		mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
>> +		rt2x00_desc_read(txwi, 0,&word);
>> +		tx_mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
>>    		__set_bit(TXDONE_FALLBACK,&txdesc.flags);
>> -		txdesc.retry = mcs - min(mcs, real_mcs);
>> +		txdesc.retry = tx_mcs - min(tx_mcs, mcs);
>>      
> Maybe you could avoid renaming and redefining variables to make your
> patch more readable?  Alternatively, you could do the renaming first in
> a separate patch.  You can use interdiff to create a difference between
> patches i.e. subtract the cleanups from the main patch.
>
>    

Renaming will be removed.
