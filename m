Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60399 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab2BKTiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 14:38:52 -0500
Received: by werb13 with SMTP id b13so2717148wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Feb 2012 11:38:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120211150152.4823.8570.stgit@ae>
References: <20120211150152.4823.8570.stgit@ae>
Date: Sat, 11 Feb 2012 11:38:50 -0800
Message-ID: <CAJ-VmonJBKuwYtd681Y9gaWxEiNwap8mQfvDjOHiy9Eynn5ayA@mail.gmail.com> (sfid-20120211_203855_808960_55EDAC7C)
Subject: Re: [PATCH] ath9k: stop on rates with idx -1 in ath9k rate control's .tx_status
From: Adrian Chadd <adrian@freebsd.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	John W Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On 11 February 2012 07:01, Pavel Roskin <proski@gnu.org> wrote:
> Rate control algorithms are supposed to stop processing when they
> encounter a rate with the index -1.  Checking for rate->count not being
> zero is not enough.
>
> Allowing a rate with negative index leads to memory corruption in
> ath_debug_stat_rc().
>
> One consequence of the bug is discussed at
> https://bugzilla.redhat.com/show_bug.cgi?id=768639
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> Cc: stable@vger.kernel.org

Great catch!



Adrian
