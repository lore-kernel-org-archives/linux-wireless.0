Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36774 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbcGSNKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 09:10:50 -0400
Received: by mail-wm0-f43.google.com with SMTP id q128so18878780wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 06:10:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw4GQknawtp6Lo3ZM8=qW=p2eTnZ_krC7AvnNbKwp8R5SQ@mail.gmail.com>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <CAA93jw6=_pemSUjk3dje1GmnTzrs+=pEdza4j1Wjtrw+VKNdNg@mail.gmail.com>
 <097af8e4-5393-8e1b-1748-36233e605867@nbd.name> <CAA93jw4GQknawtp6Lo3ZM8=qW=p2eTnZ_krC7AvnNbKwp8R5SQ@mail.gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 19 Jul 2016 15:10:48 +0200
Message-ID: <CA+BoTQnb4ynzSFs-2btkg-uqXUmfZwMa76DhRL6weu9H48rCAA@mail.gmail.com> (sfid-20160719_151054_181338_D4934359)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Dave Taht <dave.taht@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>, make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 July 2016 at 16:02, Dave Taht <dave.taht@gmail.com> wrote:
[...]
>>> tcp_limit_output_bytes is?
>> 262144
>
> I keep hoping to be able to reduce this to something saner like 4096
> one day. It got bumped to 64k based on bad wifi performance once, and
> then to it's current size to make the Xen folk happier.

Not sure if it's possible. You do need this to be at least as big as a
single A-MPDU can get. In extreme 11ac cases it can be pretty big.

I recall a discussion from a long time ago and the tcp limit output
logic was/is coupled with the assumption that tx-completions always
come max 1ms after tx submission. This is rather tricky to *guarantee*
on wifi, especially with firmware blobs, big aggregates, lots of
stations and retries.


Michał
