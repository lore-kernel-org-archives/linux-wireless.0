Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:3845 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXKES1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 13:27:35 -0500
Received: by py-out-1112.google.com with SMTP id u77so3209124pyb
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2007 10:27:34 -0800 (PST)
Message-ID: <43e72e890711051027tecf4770q59c6ea24516c852@mail.gmail.com> (sfid-20071105_182757_590616_53D51597)
Date: Mon, 5 Nov 2007 13:27:34 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Problem with wireless-2.6
Cc: "John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <472F57A6.3020107@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <472F57A6.3020107@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/5/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> John,
>
> I did the following set of steps:
>
> git clone --reference ~/linux-2.6 \
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git junk
>
> cd junk
> git checkout -b everything origin/everything
> git pull
> Warning: No merge candidate found because value of config option
>          "branch.everything.merge" does not match any remote branch fetched.
> No changes.
>
> I know that when I get the above warning, my branch "everything" is never updated. My previous
> wireless-2.6 tree was stuck at 2.6.23-rc9, whereas "git describe" lists the new tree at
> v2.6.24-rc1-155-g792296c.
>
> What am I doing wrong?

I am not sure if you can 'pull' from a branch, I think have to pull
from the master and then rebase on the brancehs:

git-checkout master
git-pull
git-checkout junk
git-rebase origin/everything

  Luis
