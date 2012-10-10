Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49141 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756867Ab2JJSWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:22:09 -0400
Message-ID: <1349893320.2035.4.camel@joe-AO722> (sfid-20121010_202234_250507_0DB25F9C)
Subject: Re: [PATCH V3] ath/ath9k/ar9003_eeprom.c: Remove semicolon after if
From: Joe Perches <joe@perches.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 10 Oct 2012 11:22:00 -0700
In-Reply-To: <1349887097-24980-1-git-send-email-peter.senna@gmail.com>
References: <1349038599-22026-1-git-send-email-peter.senna@gmail.com>
	 <1349887097-24980-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-10 at 18:38 +0200, Peter Senna Tschudin wrote:
> This patch remove a semicolon after if(...) that is preventing the
> error check to work correctly. Removing this semicolon will change the
> code behavior, but this is intended.
> 
> The semantic patch that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r1@
> position p;
> @@
> if (...);@p

this semantic patch would be a lot less tedious to
inspect the results if it excluded else after the
semicolon.

I've used perl for more or less the same output.

