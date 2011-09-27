Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56420 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1I0VAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 17:00:43 -0400
Received: by yib18 with SMTP id 18so5687700yib.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 14:00:42 -0700 (PDT)
Message-ID: <4E823976.2090407@lwfinger.net> (sfid-20110927_230047_141959_C7EFB4AE)
Date: Tue, 27 Sep 2011 16:00:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
CC: 'Chaoming_Li' <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogUlRMODE5MlNFIGFuZCA=?=
 =?UTF-8?B?ODAyLjExbiBwcm9ibGVt?=
References: <4E77AECF.7090001@gmail.com> <4E820130.7080801@gmail.com>
In-Reply-To: <4E820130.7080801@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 12:00 PM, Stefan Zwanenburg wrote:
> I've sent the below mail quite some time ago to Larry Finger and Chaoming Li,
> but am now unsure if it has actually arrived. Also, I thought maybe I'm not
> getting a response because of the fact I didn't CC the mailing list (which I
> didn't because of the attachment; I thought that would be frowned upon).
> Now, I don't want to come across as impatient, but it would mean a lot to me if
> the source of the problem were to be found.
>
> My sincerest apologies if attachments don't belong on the mailing list, and/or
> if this message is a duplicate!
>
> Stefan Zwanenburg
>
> -------- Original Message --------
> Subject: 	Re: 答复: 答复: 答复: RTL8192SE and 802.11n problem
> Date: 	Mon, 19 Sep 2011 23:06:23 +0200
> From: 	Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
> To: 	李朝明 <chaoming_li@realsil.com.cn>
> CC: 	'Larry Finger' <Larry.Finger@lwfinger.net>
>
>
>
> On 09/19/2011 10:04 PM, Stefan Zwanenburg wrote:
>>  On 09/19/2011 06:41 AM, 李朝明 wrote:
>>>  Dear Sir:
>>>
>>>  	Yes, sniffer can help, Could you help to catch the authentication
>>>  and association packet and send it to me。
>>>
>>>  Best Regards，
>>>  lizhaoming
>>>
>>  Find below the output of wpa_supplicant with the -ddd switch. If that is
>>  not the information you required (ie: you need even rawer logging or
>>  somesuch), please tell me what I need to do, or where I might find the
>>  information to do what I need to do.
> So I got some help on how to sniff the association process. Please find
> attached a dump of said process.

Sorry to not answer earlier. I was busy and I also hoped that Chaoming would 
handle this part.

I did a dump of the authentication and association process with my RTL8191SE and 
my AP. For both systems, the authentication packets are identical, as are the 
association request and response. The capability flags are identical.

This is where the two sequences differ: My AP sends an action frame with

No.     Time        Source                Destination           Protocol Info
       9 0.010970    Netgear_be:2b:44      RealtekS_72:02:18     IEEE 802.11 
Action, SN=2120, FN=0, Flags=........

Frame 9: 33 bytes on wire (264 bits), 33 bytes captured (264 bits)
     Arrival Time: Sep 27, 2011 14:47:33.529328000 CDT
     Epoch Time: 1317152853.529328000 seconds
     [Time delta from previous captured frame: 0.004135000 seconds]
     [Time delta from previous displayed frame: 0.004135000 seconds]
     [Time since reference or first frame: 0.010970000 seconds]
     Frame Number: 9
     Frame Length: 33 bytes (264 bits)
     Capture Length: 33 bytes (264 bits)
     [Frame is marked: False]
     [Frame is ignored: False]
     [Protocols in frame: wlan]
IEEE 802.11 Action, Flags: ........
     Type/Subtype: Action (0x0d)
     Frame Control: 0x00D0 (Normal)
         Version: 0
         Type: Management frame (0)
         Subtype: 13
         Flags: 0x0
     Duration: 314
     Destination address: RealtekS_72:02:18 (00:e0:4c:72:02:18)
     Source address: Netgear_be:2b:44 (c0:3f:0e:be:2b:44)
     BSS Id: Netgear_be:2b:44 (c0:3f:0e:be:2b:44)
     Fragment number: 0
     Sequence number: 2120
IEEE 802.11 wireless LAN management frame
     Fixed parameters
         Action: 0x03
             Category code: Block Ack (3)
             Action code: Add Block Ack Request (0x00)
             Dialog token: 0xee
             Block Ack Parameters: 0x1002
                 .... .... .... ...0 = A-MSDUs: Not Permitted
                 .... .... .... ..1. = Block Ack Policy: Immediate Block Ack
                 ..00 00.. = Traffic Identifier: 0x00
                 0001 0000 00.. .... = Number of Buffers (1 Buffer = 2304 Bytes): 64
             Block Ack Timeout: 0x0000
             Block Ack Starting Sequence Control (SSC): 0x0000

Your AP does not send such a packet. My STA responds with an ACK and another 
action frame:

No.     Time        Source                Destination           Protocol Info
      11 0.025115    RealtekS_72:02:18     Netgear_be:2b:44      IEEE 802.11 
Action, SN=28, FN=0, Flags=........

Frame 11: 33 bytes on wire (264 bits), 33 bytes captured (264 bits)
     Arrival Time: Sep 27, 2011 14:47:33.543473000 CDT
     Epoch Time: 1317152853.543473000 seconds
     [Time delta from previous captured frame: 0.013897000 seconds]
     [Time delta from previous displayed frame: 0.013897000 seconds]
     [Time since reference or first frame: 0.025115000 seconds]
     Frame Number: 11
     Frame Length: 33 bytes (264 bits)
     Capture Length: 33 bytes (264 bits)
     [Frame is marked: False]
     [Frame is ignored: False]
     [Protocols in frame: wlan]
IEEE 802.11 Action, Flags: ........
     Type/Subtype: Action (0x0d)
     Frame Control: 0x00D0 (Normal)
         Version: 0
         Type: Management frame (0)
         Subtype: 13
         Flags: 0x0
     Duration: 0
     Destination address: Netgear_be:2b:44 (c0:3f:0e:be:2b:44)
     Source address: RealtekS_72:02:18 (00:e0:4c:72:02:18)
     BSS Id: Netgear_be:2b:44 (c0:3f:0e:be:2b:44)
     Fragment number: 0
     Sequence number: 28
IEEE 802.11 wireless LAN management frame
     Fixed parameters
         Action: 0x03
             Category code: Block Ack (3)
             Action code: Add Block Ack Response (0x01)
             Dialog token: 0xee
             Status code: Successful (0x0000)
             Block Ack Parameters: 0x1002
                 .... .... .... ...0 = A-MSDUs: Not Permitted
                 .... .... .... ..1. = Block Ack Policy: Immediate Block Ack
                 ..00 00.. = Traffic Identifier: 0x00
                 0001 0000 00.. .... = Number of Buffers (1 Buffer = 2304 Bytes): 64
             Block Ack Timeout: 0x0000

This packet is followed by a Block Ack in both directions and then the EAPOL 1/4 
is sent.

I'm not familiar enough to know the significance of these differences, but I'm 
guessing that they may be the source of your problem.

I have to go now, but if no one describes what we are seeing, I'll review the 
802.11n specs and get back to you tomorrow.

Larry


