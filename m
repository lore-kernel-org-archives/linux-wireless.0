Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2KMTjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 14:39:16 -0500
Message-ID: <1352835582.9466.12.camel@jlt4.sipsolutions.net> (sfid-20121113_203919_586192_ADC6A050)
Subject: Re: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 13 Nov 2012 20:39:42 +0100
In-Reply-To: <2199722.SIyuOP2QQY@lx-vladimir>
References: <20121108193010.GC3354@lenteja.do-not-panic.com>
	 <1647271.ZFHae4zFan@lx-vladimir> <87txsuybw4.fsf@purkki.adurom.net>
	 <2199722.SIyuOP2QQY@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-12 at 19:58 +0200, Vladimir Kondratiev wrote:

> Yes, it make sense. I noticed also I have to use __raw_{read|write}l functions 
> to copy buffers to/from PCI iomem, as otherwise io{read|write}32 would swap 
> bytes for big endian hosts, since PCI is little endian.

No, this is what you want, they simple read/write host endian (u32)
values.

johannes

