Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64050 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2K1Pj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 10:39:59 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "mathias.kretschmer@fokus.fraunhofer.de"
	<mathias.kretschmer@fokus.fraunhofer.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>
Subject: Re: [ath9k-devel] [RFC 1/3] nl80211: add spec scan flag
Date: Wed, 28 Nov 2012 15:29:36 +0000
Message-ID: <8887AA04B7EC49479420AE48C5F94A930172CD48@NASANEXD02D.na.qualcomm.com> (sfid-20121128_164006_602554_96C0B9E3)
In-Reply-To: <20121128151916.GA6175@pandem0nium>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/28/12 7:19 AM, "Simon Wunderlich"
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:

>The main reason why I wanted to use this function is that it can be used
>while operation, that is sending power save, forbidding payload tx, etc.

Have you looked at the remain-on-channel commands?

>It seems there is no way to trigger a scan from within ath9k/debugfs,
>right?

I don't think there is nor that there should be.. Do you really need scan
operating for this? I would use remain-on-channel commands from a user
space app to go through the channels you want to analyze.

>I could also cycle channels within ath9k, but the main problem I see is
>that
>I can't turn off TX/go into power save mode from the driver, or would you
>see
>anything feasible?

Remain-on-channel should take care of that, but yes, that would not be
triggered from ath9k, but from user space.

- Jouni

