Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:42974 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab0EZQwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 12:52:05 -0400
Received: by pxi18 with SMTP id 18so2608712pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 09:52:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 09:51:45 -0700
Message-ID: <AANLkTikzEywcDi9zyJknMWkKymCVYnWQa2YXbbSDVx5o@mail.gmail.com>
Subject: Re: [RFC] wireless-regdb: Add A band in IL
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 25, 2010 at 11:49 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> A band in allowed in IL, according to official document issued by the Ministry
> of Communications: http://www.moc.gov.il/sip_storage/FILES/1/1061.pdf.
>
> 5150 - 5250 200mW e.i.r.p. OUTDOOR forbidden
> 5250 - 5350 200mW e.i.r.p. OUTDOOR forbidden DFS mandatory
>
> 40Mhz is allowed in A band for every WiFi-Alliance certified equipment.
>
> ***************************************************************
> Not to be merged for the moment
> ***************************************************************
>
> CC: Michael Green <Michael.Green@atheros.com>
> CC: David Quan <David.Quan@atheros.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  db.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index e63a43e..d49c397 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -319,6 +319,8 @@ country IE:
>
>  country IL:
>        (2402 - 2482 @ 40), (N/A, 20)
> +       (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
> +       (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS

I believe the one standing issue here is you are enabling HT40 on 5
GHz, how about enabling 2.4 GHz first, and then through a separate
patch and time/review we review the HT40 stuff, unless you are in no
rush to get 2.4 GHz enabled.

  Luis
