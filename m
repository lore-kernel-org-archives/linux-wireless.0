Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:53914 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1AGCar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:30:47 -0500
Received: by iyf40 with SMTP id 40so7639059iyf.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:30:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294361165-15308-3-git-send-email-greearb@candelatech.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-3-git-send-email-greearb@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Jan 2011 18:30:26 -0800
Message-ID: <AANLkTikjjKe96Ok09Yz1R_nqsoO+n-9X-abeF8VUoOwQ@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for debugfs.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 4:46 PM,  <greearb@candelatech.com> wrote:
> +#define ATH9K_MAX_STATIONS 1024

How about making this a Kconfig with a default to a value of the known
(by you) max workable number of STAs that one can use on ath9k, which
is modifiable to other values by power of two up to 1024. Advise in
the kconfig that if more STAs are used then some issue may arise but
should be reported (so the issue can be fixed). This way by default
normal users (you're not normal) won't enable > max known workable
stable number of STAs on ath9k.

  Luis
