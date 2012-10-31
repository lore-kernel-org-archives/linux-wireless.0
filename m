Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab2JaO1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 10:27:14 -0400
Message-ID: <1351693661.10946.0.camel@jlt4.sipsolutions.net> (sfid-20121031_152721_835259_03DE29C0)
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 31 Oct 2012 15:27:41 +0100
In-Reply-To: <1578864.KppKrIJQWb@lx-vladimir>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1351511906-19989-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <20121031012225.GY3354@lenteja.do-not-panic.com>
	 <1578864.KppKrIJQWb@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 14:57 +0200, Vladimir Kondratiev wrote:

> > You didn't also address my comments regarding WIL6210_ISR_COR #ifdef code.
> 
> I added string with short explanation in Kconfig.
> Longer explanation: while clear-on-read is good for production mode, it makes 
> debugging much harder - reading ISR registers clears interrupt, and one can no 
> more monitor ISR with debugfs. So, when debugging ISR flows - and they still 
> need some debugging - one have to use W1C mode. That's why it is still 
> present.

Since I'm CC'ed on your patches (not sure why) I'll offer the opinion
that you should add interrupt and IO access tracing rather than reading
registers with some debug thing ;)

johannes

