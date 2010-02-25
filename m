Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:26238 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759320Ab0BYX5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 18:57:03 -0500
Message-ID: <4B870E4B.40109@yahoo.com>
Date: Fri, 26 Feb 2010 00:56:59 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation. (without
 fallback change)
References: <4B85FA66.2020503@yahoo.com> <1267120092.25296.31.camel@mj>	 <4B86D0BD.3000803@yahoo.com> <1267129318.16176.15.camel@mj>
In-Reply-To: <1267129318.16176.15.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/02/2010 21:21, Pavel Roskin wrote:
> On Thu, 2010-02-25 at 20:34 +0100, Alban Browaeys wrote:
>
>    
>>> wpa_supplicant worked most of the time.  I believe the occasional
>>> failures are due to a preexisting memory corruption issue (I reported
>>> earlier that addr3 can be corrupted in probe requests).
>>>        
> That's what I'm referring to:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/46727
>
>    
Those mcu request errors are critical. Once the mcu get stuck access to 
the registers returns garbage.


>> Really interesting. I had access to an Access Point that leading to
>> such state of affait a week ago (but not for long enough to decipher the
>> issue).
>> All I could tell is the rt2x00mac_config was constantly called and as
>> this function kills
>> RX well I ended up with RX off all the time after a few initial pings.
>> Does any message comes out with mac80211 and rt2x00 debug on ?
>> As I cannot reproduce with both of my 3 different access points I am
>> kind of interested
>> by such a setup that break.
>>      
> There are no kernel messages, but ping stops working after 11 packets
> every time.  Wireshark shows that no more pings are sent.
>
>    
>> Does
>> http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=f82ab894fdac70954a50507921947facce8d8321
>> helps ?
>>      
> It's already in the kernel.
>
> This patch should help, but it was criticized and we are waiting for a
> better version:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/46713
>
>    
As I explain in 
http://article.gmane.org/gmane.linux.kernel.wireless.general/47177 DMA 
interrupts are not of any use to us if
we want to report success/failure. So this is a dead end (in fact my 
first test 2 years ago was to do exactly that . Rely on DMA0, etc
  interrutps). Back then due to l2pad issue packet were never reaching 
tx sta fifo but always dma done interrupts. Thus nothing was
received on the other side but the box reported success to send.

And it is not already in the kernel

http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=f82ab894fdac70954a50507921947facce8d8321

Try it it exactly handles the mcu request errors and corruption and prevents following access to the registers from returning garbage.
One need to reboot (once the mcu is trashed it need to be powered down).



>>>> +		rt2x00_desc_read(txwi, 1,&word);
>>>> +		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
>>>> +		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
>>>> +		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
>>>> +
>>>> +		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
>>>> +			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
>>>>
>>>>          
>>> Can we make this sanity check optional?
>>>
>>>
>>>        
>> Is this a showstopper ? Do you mean only enabling this message telling
>> something totally
>> unexpected happened in debug mode ? The sanity of the queue is pretty
>> critical for operation.
>>      
> I'm not a maintainer, I'm just trying to help with the driver, so I
> cannot declare anything a showstopper.  It was just an idea.  We can
> make it optional later.
>
>    

Anyway this can wait for you to have operational driver. I struggle to 
cleanupfor submission around 60 patches,
  the hardest to maintain behing those I did not coded liek this one but 
I am slowly integrating
the meaning of each of those).
If you want to take a look  :
http://git.popipo.fr/?p=rt2x00.git;a=shortlog;h=refs/heads/rt3070v2-next
http://git.prahal.homelinux.net/?p=rt2x00.git;a=shortlog;h=refs/heads/rtt3070v2-next-debug
the second tree behing my debug version (thus more patches but more 
printk and less ready for submission upstream).

Best regards
Alban

