Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55632 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1K3UPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 15:15:43 -0500
Date: Wed, 30 Nov 2011 15:10:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v2 0/4] Fix the way ANI is being handled for ar9100 and
 ar9340
Message-ID: <20111130201051.GC2477@tuxdriver.com> (sfid-20111130_211546_118125_2B5574B6)
References: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 27, 2011 at 07:22:10PM -0500, Nikolay Martynov wrote:
>   Currently in ath9k code there is an attempt which is meant to
> disable ANI for ar9100 and ar9340. But it doesn't really achieve
> this. All it does is disable ANI init and setup (i.e. calls to
> ath9k_hw_ani_setup and ath9k_hw_ani_init). Since ath9k_hw_ani_setup is
> not called ah->config.ani_poll_interval is never initialized (i.e. it
> is always zero) and ath_ani_calibrate always executes ANI procedures
> (over uninitialized ANI parameters).
>   Moreover, ath_ani_calibrate is being called each 1ms because
> common->ani.timer is set to zero interval because
> ah->config.ani_poll_interval==0 (and thus smallest value of all
> intervals). Normally it should not be called this often.
>   This patch changes the code so config.enable_ani is used to check if
> ANI should be performed.
>   Also, this pacthset enables ANI for ar9100 - ANI was always performed
> for this chip, but this patch fixes the fact that it was performed
> over uninitialized data.
> 
>   All comments and suggestions are appreciated.
>   Thanks.
> 
> Nikolay Martynov (4):
>   ath9k: trivial: cosmetic fix in calibration debug log
>   ath9k: change calibration debug log to output all calibration types
>   ath9k: use config.enable_ani to check if ani should be performed
>   ath9k: enable ANI for ar9100 chips

More than one of the patches in this series either adds indentation
with only spaces or even changes existing indentation with tabs
to spaces.  Please don't do this.

I'm dropping this series for the above reason.  Please feel free
to fix your editor if necessary and to revise the patches to avoid
needless and/or inappropriate whitespace changes or additions.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
