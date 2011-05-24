Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46682 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1EXAL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 20:11:56 -0400
Received: by iwn34 with SMTP id 34so5292516iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 17:11:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4dce9c85.8lZEqlxFlQS542Cf%Larry.Finger@lwfinger.net>
References: <4dce9c85.8lZEqlxFlQS542Cf%Larry.Finger@lwfinger.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 May 2011 17:11:36 -0700
Message-ID: <BANLkTikWQki-_Ec3cjd8U8BNzbeBoh_jAw@mail.gmail.com> (sfid-20110524_021159_805535_5BE11A3D)
Subject: Re: [PATCH] rtlwifi: rtl8192c-common: rtl8192ce: Fix for HT40 regression
To: Larry Finger <Larry.Finger@lwfinger.net>, Greg KH <greg@kroah.com>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 8:15 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The changes that were made to rtl8192ce when rtl8192cu was added broke
> HT40. The errors included a typo in rtlwifi, a missing routine in
> rtl8192ce and a missing callback of that routine in rtl8192c-common.
>
> This patch fixes the regression reported in Bug #35082.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> John,
>
> I know this is very late, but was just discovered. If it does not make
> 2.6.39, then it needs to be Cc'd to stable for .39.
>
> Thanks,
>
> Larry

But in order to be applicable to 2.6.39 it required some slight
modifications, namely only the first two hunks are applicable and the
second hunk required a change. You can get my own version of the
backport here, when it comes time to merge into 2.6.39.

http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-wireless-2.6.git;a=commitdiff;h=3fdb69033149ca19791eb16c23be976f00f8daaa

  Luis
