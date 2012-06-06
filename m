Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab2FFK0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:26:11 -0400
Message-ID: <1338978370.4513.58.camel@jlt3.sipsolutions.net> (sfid-20120606_122614_679794_668099DE)
Subject: Re: [PATCH 4/4] mac80211: invoke the timer only with correct
 dot11MeshHWMPRootMode value
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Wed, 06 Jun 2012 12:26:10 +0200
In-Reply-To: <1338978039-4269-5-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122111_793392_49BF46F0)
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
	 <1338978039-4269-5-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120606_122111_793392_49BF46F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 18:20 +0800, Chun-Yeow Yeoh wrote:

> -		    !conf->dot11MeshHWMPRootMode) {
> -			conf->dot11MeshHWMPRootMode = 1;
> +		    !(conf->dot11MeshHWMPRootMode > 1)) {
> +			conf->dot11MeshHWMPRootMode = 4;

if you have constants, why not use them?

johannes

