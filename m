Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43819 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1ASLHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 06:07:30 -0500
Received: by qwa26 with SMTP id 26so695941qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 03:07:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092042.19628.81667.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092042.19628.81667.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 06:07:28 -0500
Message-ID: <AANLkTinNaMK_QUDVRxQ32XtKiQXmyDeuHGoCv2rWnW=e@mail.gmail.com>
Subject: Re: [PATCH 2/8] ath5k: Simplify loop when setting up channels
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 4:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> Simplify confusing code and get rid of an unnecessary variable.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>


> @@ -285,8 +285,8 @@ ath5k_copy_channels(struct ath5k_hw *ah,
>                return 0;
>        }
>
> -       for (i = 0, count = 0; i < size && max > 0; i++) {
> -               ch = i + 1 ;
> +       count = 0;
> +       for (ch = 1; ch < size && count <= max; ch++) {

Should be <= size now, right?  And maybe rename size to max_channel
or something like that.

-- 
Bob Copeland %% www.bobcopeland.com
