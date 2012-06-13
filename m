Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2FMIVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 04:21:08 -0400
Message-ID: <1339575664.4519.14.camel@jlt3.sipsolutions.net> (sfid-20120613_102115_438948_00822232)
Subject: Re: [PATCH v3 2/4] mac80211: implement the proactive PREQ generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Wed, 13 Jun 2012 10:21:04 +0200
In-Reply-To: <1339487445-25428-3-git-send-email-yeohchunyeow@gmail.com> (sfid-20120612_095152_340542_5D4036A2)
References: <1339487445-25428-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339487445-25428-3-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120612_095152_340542_5D4036A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 15:50 +0800, Chun-Yeow Yeoh wrote:

>  /**
> + * enum - mesh PREQ element flags

Please fix this -- it has to be

enum ieee80211_preq_flags - ...

I was going to fix it up for you, but there are a lot of instances here.

> +/**
> + * enum - mesh PREQ element per target flags
> + *
> + * @TO_FLAG: target only subfield
> + * @USN_FLAG: unknown target HWMP sequence number subfield
> + */
> +enum ieee80211_preq_target_flags {
> +	TO_FLAG		= 1<<0,
> +	USN_FLAG	= 1<<2,

Since this is a fairly generic header, maybe they should have some
prefixes, at least IEEE80211_ or maybe IEEE80211_PREQ_?

> +/**
> + * enum - root mesh STA mode identifier used by dot11MeshHWMPRootMode
> + *
> + * @IEEE80211_NO_ROOT: the mesh STA is not a root mesh STA (default)
> + * @IEEE80211_ROOT: the mesh STA is a root mesh STA if greater than this value
> + * @IEEE80211_PROACTIVE_PREQ_NO_PREP: the mesh STA is a root mesh STA supports
> + *	the proactive PREQ with proactive PREP subfield set to 0
> + * @IEEE80211_PROACTIVE_PREQ_WITH_PREP: the mesh STA is a root mesh STA
> + *	supports the proactive PREQ with proactive PREP subfield set to 1
> + * @IEEE80211_PROACTIVE_RANN: the mesh STA is a root mesh STA supports
> + *	the proactive RANN
> + */
> +enum {

That enum probably needs a name for kernel-doc to work

> +	IEEE80211_NO_ROOT = 0,

These should have more specific prefixes I think?

johannes

