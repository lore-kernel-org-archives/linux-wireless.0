Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:32807 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0DSKPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 06:15:15 -0400
Received: by ewy20 with SMTP id 20so1362427ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 03:15:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004190924.25709.br1@einfach.org>
References: <20100412073847.28215.87571.stgit@tt-desk> <20100416155907.6e33c722@dhcp-lab-109.englab.brq.redhat.com>
	<201004190924.25709.br1@einfach.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 19 Apr 2010 12:14:53 +0200
Message-ID: <o2g69e28c911004190314w89e7a220y825cd563f6d98e3b@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath5k: Use high bitrates for ACK/CTS
To: Bruno Randolf <br1@einfach.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 19, 2010 at 2:24 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Friday 16 April 2010 22:59:07 Stanislaw Gruszka wrote:
>> On Mon, 12 Apr 2010 16:38:47 +0900
>>
>> Bruno Randolf <br1@einfach.org> wrote:
>> > There was a confusion in the usage of the bits AR5K_STA_ID1_ACKCTS_6MB
>> > and AR5K_STA_ID1_BASE_RATE_11B. If they are set (1), we will get lower
>> > bitrates for ACK and CTS. Therefore ath5k_hw_set_ack_bitrate_high(ah,
>> > false) actually resulted in high bitrates, which i think is what we want
>> > anyways. Cleared the confusion and added some documentation.
>>
>> I thought ACK and other control frames have to be modulated at slow/robust
>> bitrates, but can't remember where I read that ...
>
> this has been discussed on ath5k-devel before. i'm copying it here. please let
> me know if i missed something...
>
> (https://lists.ath5k.org/pipermail/ath5k-devel/2010-March/003391.html)
>
> control frames have to be sent at one of the lower bitrates - one of the
> "basic rates". in G mode these are 1, 2, 5.5, 11, 6, 12, 24Mbps.

Aren't basic rates defined so as to exclude any OFDM rates? I.e. are
6M, 12M and 24M really basic rates?

>
> this is from the 802.11g spec:
> "a STA responding to a received frame shall transmit its Control Response
> (either CTS or ACK) frames at the highest rate in the BSSBasicRateSet that is
> less than or equal to the rate of the immediately previous frame in the frame
> exchange sequence (as defined in 9.7)"
>
> basically we have to make a tradeoff here: using lower rates for ACK/CTS will
> improve reliability, but lower performance. for example i could get only
> 10Mbps truput with ACK/CTS at the lowest bitrates and RTS/CTS enabled
> (iwconfig wlan0 rts 250) and i can get more than 20Mbps with higher bitrates.
> so i think it's worth to use high bitrates. actually also this should be
> tuneable for the user, too...
>
> bruno
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
