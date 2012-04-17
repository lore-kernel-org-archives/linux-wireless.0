Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kingswood-consulting.co.uk ([88.97.16.53]:37489 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755622Ab2DQNzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 09:55:53 -0400
Message-ID: <4F8D765D.2090705@kingswood-consulting.co.uk> (sfid-20120417_155557_563705_963CACAD)
Date: Tue, 17 Apr 2012 14:55:41 +0100
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic with brcm4313 (kernel 3.2.2)
References: <jgjoab$l54$1@dough.gmane.org> <4F2E6C34.6060903@broadcom.com> <4F2E9651.5020601@kingswood-consulting.co.uk> <4F8D471F.5070901@broadcom.com> <4F8D60FC.2090301@kingswood-consulting.co.uk> <4F8D6793.8090701@broadcom.com>
In-Reply-To: <4F8D6793.8090701@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/04/12 13:52, Arend van Spriel wrote:
> On 04/17/2012 02:24 PM, Frank Kingswood wrote:
>> Hi Arend,
>>> I noticed in some log you sent that your regulatory domain is set to
>>> GB, which makes sense. I submitted a patch [1] last week so could you
>>> try that and let me know the results.
>> [re-sending as plain text]
>>
>> Thanks for the update. Yes, my AP is on channel 13 so might be affected
>> by this.
>>
>> That line is in brcms_c_wait_for_tx_completion()
>>
>> main.c,8006 WARN_ON_ONCE(timeout == 0);
>>
>> Would using another channel be any different for this?
>>
>
> I actually did not expect that warning to come up with the patch in place. 
> So if you can try another channel in 1-11 range and let me know the result, 
> I might be able to make some sense of it all.
Sorry, I misremembered.
It was already on channel 11, but it had 20/40 MHz bandwidth selected with 
channel 9 as the extension channel. That might have been OK on channel 13, 
but I think these two overlap.

Also I'm not sure if this is a standard mode, so I've turned it to just 
802.11n+g mode, with 20MHz BW on channel 7 now. Output from "iw dev wlan0 
scan" for reference.

Attempting to connect with NM no longer gives the kernel warning, but stull 
no luck.

BSS 00:22:57:xx:xx:xx (on wlan0)
     TSF: 1796346187 usec (0d, 00:29:56)
     freq: 2442
     beacon interval: 333
     capability: ESS Privacy ShortSlotTime (0x0411)
     signal: -44.00 dBm
     last seen: 476 ms ago
     SSID: xxxxxxxxxxxx
     Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0
     DS Parameter set: channel 7
     Extended supported rates: 6.0 12.0 24.0 48.0
     Country: GB    Environment: Indoor/Outdoor
         Channels [1 - 11] @ 16 dBm
     TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
     ERP: Barker_Preamble_Mode
     HT capabilities:
         Capabilities: 0x1ec
             HT20
             SM Power Save disabled
             RX HT20 SGI
             RX HT40 SGI
             TX STBC
             RX STBC 1-stream
             Max AMSDU length: 3839 bytes
             No DSSS/CCK HT40
         Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
         Minimum RX AMPDU time spacing: 4 usec (0x05)
         HT RX MCS rate indexes supported: 0-15
         HT TX MCS rate indexes are undefined
     HT operation:
          * primary channel: 7
          * secondary channel offset: no secondary
          * STA channel width: 20 MHz
          * RIFS: 0
          * HT protection: non-HT mixed
          * non-GF present: 1
          * OBSS non-GF present: 0
          * dual beacon: 0
          * dual CTS protection: 0
          * STBC beacon: 0
          * L-SIG TXOP Prot: 0
          * PCO active: 0
          * PCO phase: 0
     Extended capabilities: HT Information Exchange Supported
     RSN:     * Version: 1
          * Group cipher: CCMP
          * Pairwise ciphers: CCMP
          * Authentication suites: PSK
          * Capabilities: PreAuth (0x0001)
     WMM:     * Parameter version 1
          * BE: CW 15-1023, AIFSN 3
          * BK: CW 15-1023, AIFSN 7
          * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
          * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec

Frank
