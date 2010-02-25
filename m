Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:36165 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933119Ab0BYTeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 14:34:24 -0500
Message-ID: <4B86D0BD.3000803@yahoo.com>
Date: Thu, 25 Feb 2010 20:34:21 +0100
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
References: <4B85FA66.2020503@yahoo.com> <1267120092.25296.31.camel@mj>
In-Reply-To: <1267120092.25296.31.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/02/2010 18:48, Pavel Roskin wrote:
> Hello!
>
> I have tested both patches on the real hardware, and I don't see any
> regressions.  Unfortunately, the issue with interrupts is still there,
> so ping stops after 11 packets, which limited my ability to test the
> change extensively.  That said, I was able to use wpa_supplicant and
> dhcp to get an IP address using the patched driver in the station mode.
>
> wpa_supplicant worked most of the time.  I believe the occasional
> failures are due to a preexisting memory corruption issue (I reported
> earlier that addr3 can be corrupted in probe requests).
>
>    

Really interesting. I had access to an Access Point that leading to
such state of affait a week ago (but not for long enough to decipher the 
issue).
All I could tell is the rt2x00mac_config was constantly called and as 
this function kills
RX well I ended up with RX off all the time after a few initial pings.
Does any message comes out with mac80211 and rt2x00 debug on ?
As I cannot reproduce with both of my 3 different access points I am 
kind of interested
by such a setup that break.
Does 
http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=f82ab894fdac70954a50507921947facce8d8321 
helps ?
It is my next patch in the pipe . Is supposed to only take care of 
reseting the DMA engine and MCU one thus
should only prevents messages about failure to send mcu request after boot.
But if you have such an error you could have incorrect initialization of 
the radio thus more issues afterwards.

Note that station mode is not properly working as master (benoit 
decipher we were not sending beacons).
> Unfortunately, the patches include corrupt whitespace, so they had to be
> applied by "patch -l".  Also, there are trailing tabs in two places.
> That's not a big deal, but it's better avoided.  Please consider using
> git or stgit to send patches.
>
>    
>> +	for (i=0; i<256; i++) {
>>      
> checkpatch.pl complains about spacing.  There should be spaces around
> "=" and"<"
>
>    
>> +		txwi = (__le32 *)(entry->skb->data -
>> +				  rt2x00dev->hw->extra_tx_headroom);
>>      
> I really don't see any point in introducing wrong code in one patch and
> fixing it in another.  I would just join the patches.
>
> When bisecting for a problem, landing at a broken commit can lead to a
> lot of wasted time.
>
>    
Changes done in just sent patch version.

>> +		rt2x00_desc_read(txwi, 1,&word);
>> +		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
>> +		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
>> +		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
>> +
>> +		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
>> +			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
>>      
> Can we make this sanity check optional?
>
>    
Is this a showstopper ? Do you mean only enabling this message telling 
something totally
unexpected happened in debug mode ? The sanity of the queue is pretty 
critical for operation.

Best regards
Alban
