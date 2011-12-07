Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48811 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab1LGOEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 09:04:15 -0500
Date: Wed, 7 Dec 2011 19:34:08 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <compat@orbit-lab.org>,
	Paul Stewart <pstew@google.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [RFC v2 2/2] cfg80211: Restore orig channel values upon
 disconnect
Message-ID: <20111207140406.GA13140@vmraj-lnx.users.atheros.com> (sfid-20111207_150418_798916_8097B403)
References: <1322518991-7040-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1322518991-7040-3-git-send-email-mcgrof@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1322518991-7040-3-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 28, 2011 at 05:23:11PM -0500, Luis R. Rodriguez wrote:
> From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> When we restore regulatory settings the world regulatory domain
> is properly reset on cfg80211 (or user prefered regulatory domain)
> but we were never setting back channel values for drivers that use
> WIPHY_FLAG_CUSTOM_REGULATORY. Set these values up again by using
> the orig_ channel parameters.
> 
> This fixes restoring custom regulatory settings upon disconnect
> events.
> 
> Cc: compat@orbit-lab.org
> Cc: Paul Stewart <pstew@google.com>
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Cc: Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
>  net/wireless/reg.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
John,

Can you please push these two RFC patches?

--
Rajkumar
