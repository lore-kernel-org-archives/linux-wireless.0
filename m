Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3FDKnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:43:35 -0400
Message-ID: <1370342611.8287.12.camel@jlt4.sipsolutions.net> (sfid-20130604_124338_594901_96D3A5E2)
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Tue, 04 Jun 2013 12:43:31 +0200
In-Reply-To: <1370328271-9523-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1370328271-9523-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-04 at 09:44 +0300, Vladimir Kondratiev wrote:

> +	if (genlmsg_end(msg, hdr) < 0) {
> +		nlmsg_free(msg);
> +		return;
> +	}

I'm guessing you're going to (have to) respin for Ilan's comments --
please remove the bogus error checking here then, genlmsg_end() can only
ever return >= 0 since it returns msg->len.

johannes

