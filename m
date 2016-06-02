Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53037 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbcFBJnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 05:43:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.7 FIX] brcmfmac: fix lockup when removing P2P interface after event timeout
In-Reply-To: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Fri, 27 May 2016
 21:53:14 +0200")
References: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
Date: Thu, 02 Jun 2016 12:42:55 +0300
Message-ID: <87eg8glye8.fsf@purkki.adurom.net> (sfid-20160602_114337_140547_7E16FCBE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Removing P2P interface is handled by sending a proper request to the
> firmware. On success firmware triggers an event and driver's handler
> removes a matching interface.
>
> However on event timeout we remove interface directly from the cfg80211
> callback. Current code doesn't handle this case correctly as it always
> assumes rtnl to be unlocked.
>
> Fix it by adding an extra rtnl_locked parameter to functions and calling
> unregister_netdevice when needed.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Arend, are you ok to push this to 4.7?

-- 
Kalle Valo
