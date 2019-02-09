Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18772C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 16:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7152217D8
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 16:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcBSMK+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfBIQ3f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 11:29:35 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37746 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfBIQ3e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 11:29:34 -0500
Received: by mail-ot1-f67.google.com with SMTP id s13so11014619otq.4
        for <linux-wireless@vger.kernel.org>; Sat, 09 Feb 2019 08:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=c2hJH9r6QUDPSAQesNEnBMaBBpoSYcxtDDQkVBL6BkE=;
        b=lcBSMK+H0NzeJysJHlrY5duBuC868r9nsm0PzCzSTXhFGqHSass/AaCpVr6SDYOoyi
         kbUu/uWv+IMcr0KwRoBeTc2TlSlzc0J5tQEHJMSzYTM6Vs7S4IhGiaf3pSFbzjG8OMl4
         y7h6/RsTlaEJi6SsxHQum8KSlU5GM9jeC489q9+IKWI7kGFXkrzfYg6cW285kRMaVdSC
         3bIFb9j6H3aZF28F7x1ks1Q4Xm5Bhf0mqeqBys0ok9fyTWQi7iooYaQ9sdVy/V4HweUc
         0ZTNdWKHU3t9IbOCdeVSPJ+oRtFCVq2oQ9OGtUMvhQHBc58ZPWXI8FTXdBVDQE9WTiId
         I2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=c2hJH9r6QUDPSAQesNEnBMaBBpoSYcxtDDQkVBL6BkE=;
        b=uR519yfdibhtomGC75Rxvq14Aycf2zpYNPmJ0q763tcK1wxEuo0jUg6xCk5HrneNFe
         zEx7hRleW3HT+fEFZ84MPWfhOmtcdIfrnGmvhfKty+rjB6vBnAa4PiZysJbo1sStu3OL
         LINAwZom3U8j2j/v/qbIdwH/Z1NnM7Axor+zwrTTajBYztkOR96ZH5BcQfIeEN+2YXev
         9EtGRNlClaQgUf6ZlgiE0Gb0A6nWgduPKiEcbG23emH8h/LXLoit1Cqx0F6D8UFYqWvz
         pVnUDXRGNjtBsN5mgXwkYSaq4B6OWinI3x2noM1H+urigymEpJ4NjhgQbd2HlSXJWwLI
         Vjjw==
X-Gm-Message-State: AHQUAuYMRfBCwQKWLmqe+U8ny9nXDHElKJSSQ6TczvchoPo4nHPf+rbh
        1+aIyquwd2FvbIAkktXFStM6fIolMWPfdtr1q5k=
X-Google-Smtp-Source: AHgI3Iapq7nKB5DNQTTZZ4AbMXtdic4cNCYRUqJ3aae9pSlZpDZuBMORiQAOQB7IwVSbOPjGPS3zkMy7Li5tbOFRDi4=
X-Received: by 2002:a9d:7450:: with SMTP id p16mr17540261otk.247.1549729773622;
 Sat, 09 Feb 2019 08:29:33 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:4b14:0:0:0:0:0 with HTTP; Sat, 9 Feb 2019 08:29:33 -0800 (PST)
In-Reply-To: <20190209153850.GA19297@makrotopia.org>
References: <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com> <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com> <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
 <20190102081934.GA5300@redhat.com> <20190209110259.GA14900@redhat.com>
 <CAKR_QVK7N_NGFR+_2+6fP5iZ0j3dDbvdxJOQt3Yjwn7DMBUfYA@mail.gmail.com>
 <20190209115628.GA16082@redhat.com> <CAKR_QVJtQdRcbRMV+WDKw=N2CxLhUSo6hE8mUME2orD6JEMAmQ@mail.gmail.com>
 <20190209153850.GA19297@makrotopia.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Sat, 9 Feb 2019 17:29:33 +0100
Message-ID: <CAKR_QVJXaYyy64BBj0qz7-Rua70nKGTypV7uiysCqyR=jG_Adw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/02/2019, Daniel Golle <daniel@makrotopia.org> wrote:
> Hi Tom,
>
> On Sat, Feb 09, 2019 at 01:28:32PM +0100, Tom Psyborg wrote:
>> On 09/02/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Sat, Feb 09, 2019 at 12:11:03PM +0100, Tom Psyborg wrote:
>> >> Can you reproduce interface freeze with this patch if you enable debug
>> >> options to print all dbg messages?
>> >
>> > Haven't tried that, but I expect enabling debug messages will
>> > cause troubles at hardware where printk make CPU hog.
>> >
>> > Stanislaw
>> >
>>
>> Take a look at my comment from 23.01.2019. on this link:
>> https://bugs.openwrt.org/index.php?do=details&task_id=2018
>> There might be a chance dbg printks do not cause problems.
>
> This is very likely just overheat because of missing TSSI. It happends
> on boards where MT7620A is used without heatsink (and easy to
> reproduce, I've tried. We just need TSSI and for bad board design it
> will mean limiting to one TX-queue soon after serious traffic starts).
> We should tell those users to glue heatsink on the chip for $0.05 they
> can fix this in hardware -- and implement TSSI to mitigate at least the
> very worst effects (such as hardware stuck until reset).
> So dkg printks can make this worse, of course, because logging overhead
> also burns CPU cycles and increases system load.
>
> I remember in Rt5350 (and other predecessors of Rt6352 aka. MT7620)
> also had problems like that and it was possible to improve it by all
> sorts of things like removing power from unused ports of the Ethernet
> switch -- so for those boards (like Xiaomi MiWiFi mini) even this maybe
> the trick, because they also only use 3 out of 5 ports, and maybe we
> need to try harder to disable the power of unused ports (and also those
> without cable plugged in only periodicly power them up and check for
> link)....
>
> Cheers
>
> Daniel
>

Disagree. MT7620 in Xiaomi MiWiFi mini has thermal pad sticked to
enough large metal shielding that is sticked with another thermal pad
to even bigger metal part of case. So thermal dissipation in that case
is very good.
Also with pandorabox firmware 200Mbps of stable throughput is possible
without any throttling which I believe would not be the case if the
cooling system wasn't reliable.

Back on subject, this patch is tested and proven to work, so ACK from me.
