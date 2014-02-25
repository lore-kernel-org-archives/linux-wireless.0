Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaBYT7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:59:45 -0500
Message-ID: <1393358376.4170.22.camel@jlt4.sipsolutions.net> (sfid-20140225_205949_264108_BA2FE7F1)
Subject: Re: [PATCH 01/14] brcmfmac: add delay before unregistering the
 network device
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Feb 2014 20:59:36 +0100
In-Reply-To: <1393356639-19169-2-git-send-email-arend@broadcom.com> (sfid-20140225_203048_842452_A39499B6)
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
	 <1393356639-19169-2-git-send-email-arend@broadcom.com>
	 (sfid-20140225_203048_842452_A39499B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 20:30 +0100, Arend van Spriel wrote:
> Upon deleting the interface a cfg80211_disconnected() is called under
> rtnl_lock. Right after the unlocking the rtnl_lock we unregister the
> network device. This patch adds delay before unregister so cfg80211
> can handle disconnect and notify wpa_supplicant.

> +				/* make sure cfg80211 can send disconnect event
> +				 * before unregistering the netdevice below.
> +				 */
> +				msleep(100);

This has got to be one of the worst hacks I've seen in wireless so
far ... :)

johannes

