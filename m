Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D47C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 16:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904F421019
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 16:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="jGa7XipT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 904F421019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbeK3DMs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 22:12:48 -0500
Received: from mail.toke.dk ([52.28.52.200]:44539 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbeK3DMs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 22:12:48 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543507614; bh=fS0b6oWvAVBbdxIB6+G6xBg2SyYYP0tUfeFQm7XB+gI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=jGa7XipTq6A/wih5AlCgZDgaFuVrpLO4ocEkLuO3oBxWO+I9eQnbrJ2DrTj0NuxzA
         skebdJIbuWNEgCEoDFiBmc7oxNraFpXan046ilHmvFjBSO7xz+BOAAqwlkbGmx0vvf
         5fHBgIhCk6NbR7T9P+7t1buLw542OUQaq/BNC3RZOB4pzJ9DiKquIyX6prAfXn3cx2
         Q5q5UkOM19UhgupJjsKRiMp9UDPLQ1upqQ9LUe0yFP3IX/Ph3map9tG88heC0UoQcd
         nNsPCIeDfyNWWP67sBDWNar18d9Sx0WeH+A72XropRKdFMTc0vdFg+VI7nwZdReBYh
         4u3ZuYpbivkQw==
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, nbd@nbd.name,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <20181129154502.GA29066@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128164306.0135ca83@redhat.com> <20181129103054.GA6365@localhost.localdomain> <87sgzkqaip.fsf@toke.dk> <20181129135825.GD6365@localhost.localdomain> <87h8g0q8py.fsf@toke.dk> <20181129154502.GA29066@localhost.localdomain>
Date:   Thu, 29 Nov 2018 17:06:54 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <8736rjrhpd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>>=20
>> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >>=20
>> >> >> On Wed, 28 Nov 2018 13:36:26 +0100
>> >> >> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> wrote:
>> >> >>=20
>
> [...]
>
>> >> >
>> >> > I guess it will be enough to avoid loading a 'non-WiFi' bpf program=
 on
>> >> > a 802.11 netdevice (and vice versa). We could add a flag (or someth=
ing
>> >> > similar) in XDP_SETUP_PROG section of netdev_bpf data structure and
>> >> > use ieee80211_ptr netdevice pointer in order to guarantee that the =
bpf
>> >> > program will work on the expected 'frame-type'
>> >>=20
>> >> Yeah, a flag would be good; we've been discussing that for other XDP =
use
>> >> cases; it's not a done deal yet, but I think it would be useful.
>> >
>> > Do you think something wifi specific is ok (e.g bool wifi) or do you p=
refer
>> > something more general (e.g u32 frame_type)?
>>=20
>> My thought was a feature flag where the program can set a flag which
>> means "I expect 802.11 frames", and the driver can set a flag saying "I
>> emit 802.11 frames", and if those two flags don't match, the verifier
>> can refuse to load the program. This would not be fool-proof (an XDP
>> program can still corrupt things if written incorrectly), but it would
>> at least protect against the most obvious mistakes.
>
> I guess we can use iee80211_ptr in dev_xdp_install to double check if it =
is
> allowed to upload a 802.11 (or 802.3) bpf program

Yeah, I think it's more an issue of convincing the wider XDP community
that support for feature flags is in fact needed ;)

-Toke
