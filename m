Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29843C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4BD20868
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/HK+ZJ+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4BD20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbeK3Ar2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:47:28 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]:46659 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbeK3Ar2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:47:28 -0500
Received: by mail-qt1-f179.google.com with SMTP id y20so1913919qtm.13;
        Thu, 29 Nov 2018 05:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i0tMYyx95RfrhexGklvC88Z3yhZc86SYfSpzIth7GqI=;
        b=W/HK+ZJ+EKnrnNT+IxGe3o8IFe5+6F6jEx15ZabnUX6asxfvb7SnHywxne4m1ptA1z
         /Ep90FJSGxnBac4YC3zgf5yjSbPt1bxAMMI6SrUCaWD5D7cPfJFeUACNClf7YEATNuG1
         zwXpStXlw508qb1OSD17AKkQlqWjpn2ybeZ+IXlZIHXgtzakV9VbjcfRKvXwY/UaPCLS
         iHK3UJU9Ea3kE9TYvR630fgzD8bzNIZN8TMebS4LSDoUZu+UyuNlyUHdUzVXc7xVZM9l
         VgVShcfSViCWUSIcPmgY/NhnmQw10M9HwCQ5bE80N4xtAyOkgpziLcfNZC65pRlKd1Pl
         E4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i0tMYyx95RfrhexGklvC88Z3yhZc86SYfSpzIth7GqI=;
        b=Evh6a4j00C7XHBcbsgm/ijnJA5wSJ+Pdu1cZ8G6UgPC0U6yCTlfmQkNT8Skpjo0wfR
         B/9+zcGE2TSEUtKZMpgZqsWXpZn06gaNaJwtdg3m2VFr/0tzoj1LfgN5rbQxcOlDoirN
         o7px6stckHw5FItFK8lho0aMW8ufTK1/dkaxP+pMs5YGxVVFnbUorG+VmmRjp5U7orSd
         rxg4v8zzN8M6iSAsTjflJ59smb648Flz+mXfShAephQP0gQ9YCm2tB1JykCauor6eBlU
         3isllpwbRWSAf9N+Kej2s6koeN57ygDYYFx0rZsTRdY1Hi+P2oh6bOX6JskE2e2yzkKg
         7Ajg==
X-Gm-Message-State: AA+aEWYTUQXEOFDEsNBLX0sgfvhqgfggAW8pE0ht6kSZvUtfuQ1BgwF5
        umZXTzPs5VsqkF+zYo/1IMOSx7LnNqSzVZ0tsBQ=
X-Google-Smtp-Source: AFSGD/U2HD7A/FI3bh64cDD8S9effgKATSDKdkD3KPedpzGgnRYQDfsNRiufFyseAhNDOw7MJC8EiyQ5q1/E+bP3rz4=
X-Received: by 2002:a0c:db04:: with SMTP id d4mr1418383qvk.114.1543498924103;
 Thu, 29 Nov 2018 05:42:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk> <20181128164306.0135ca83@redhat.com>
 <20181129103054.GA6365@localhost.localdomain> <87sgzkqaip.fsf@toke.dk>
In-Reply-To: <87sgzkqaip.fsf@toke.dk>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Thu, 29 Nov 2018 14:41:51 +0100
Message-ID: <CABvG-CVFYNaytwaUj9YGVUp38DBP9CVYkoU6EKvbJBPNmtK0Ag@mail.gmail.com>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     lorenzo.bianconi@redhat.com, brouer@redhat.com,
        kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, borkmann@iogearbox.net,
        alexei.starovoitov@gmail.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 29 Nov 2018 at 14:31, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.d=
k> wrote:
[...]
> >> Option#3 is to say, Wifi XDP is so different that we should create a
> >> new (enum) bpf_prog_type.  And then still see if we can leverage some
> >> of the same core-code (as long as it doesn't slowdown performance).
> >>
> >
> > Do you think that Option#3 will be more 'future-proof' respect to
> > Option#1?
>
> My feeling is that WiFi devices are not sufficiently different to
> warrant a whole new program type. We risk combinatorial explosion for
> all the stuff that is the same, but now need to be tested for two (or N)
> types...

I'm not sure if my understanding is correct, but XDP seems like it can
(and intends to be able to?) act as a general purpose packet
accelerator (REDIRECT action was mentioned so I'm inferring..). In
such case you'll need to be able to perform transformations on packets
too, e.g. strip/prepend vlan tags, gre headers and what have you. The
802.3 <-> 802.11 conversion could be treated on equal terms.


Micha=C5=82
