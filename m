Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35807 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZCCPAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 10:00:25 -0500
Date: Tue, 3 Mar 2009 09:52:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mike Cui <cuicui@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Bug in iw prevents setting the "cook" monitor flag
Message-ID: <20090303145233.GB17678@tuxdriver.com> (sfid-20090303_160028_557796_2CCEEB48)
References: <7c8826910903021516t640aa84dxfbb61a278b69c740@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7c8826910903021516t640aa84dxfbb61a278b69c740@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 02, 2009 at 03:16:14PM -0800, Mike Cui wrote:
> There is an off by one error in interface.c of iw that prevents
> passing of the cook flag when creating a monitor interface. The fix is
> simple:
> 
> 
> --- a/interface.c       2009-03-02 15:11:58.748078548 -0800
> +++ b/interface.c       2009-03-02 15:12:14.695203787 -0800
> @@ -36,7 +36,7 @@ static int parse_mntr_flags(int *_argc,
>         while (argc) {
>                 int ok = 0;
>                 for (flag = __NL80211_MNTR_FLAG_INVALID;
> -                    flag < NL80211_MNTR_FLAG_MAX; flag++) {
> +                    flag < NL80211_MNTR_FLAG_MAX + 1; flag++) {
>                         if (strcmp(*argv, mntr_flags[flag]) == 0) {
>                                 ok = 1;
>                                 /*

FWIW, I think I like "x <= Y" instead of "x < Y + 1".

Also, please make sure you are following the guidelines explained here:

	http://linux.yyz.us/patch-format.html

In particular, I need a Signed-off-by line from you.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
