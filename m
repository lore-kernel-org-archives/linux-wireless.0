Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KDJIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 04:08:11 -0500
Message-ID: <1383553509.14295.0.camel@jlt4.sipsolutions.net> (sfid-20131104_100815_628600_08256E5C)
Subject: Re: [PATCH] mac80211_hwsim: Fix radiotap header for ACK frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 04 Nov 2013 09:25:09 +0100
In-Reply-To: <20131102135736.GA14411@w1.fi>
References: <20131102135736.GA14411@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-11-02 at 15:57 +0200, Jouni Malinen wrote:
> The earlier addition of rt_tsft to struct hwsim_radiotap_hdr updated
> only mac80211_hwsim_monitor_tx() to fill in the new field.
> mac80211_hwsim_monitor_ack() did not set the rt_tsft field and as such,
> leaked eight bytes of kernel memory to user space. In addition, the
> resulting radiotap header is invalid since the field offsets do not
> match. Fix these issues by defining a separate radiotap header structure
> for the ACK frame case which does not use all the fields.

Applied, thanks.

johannes

