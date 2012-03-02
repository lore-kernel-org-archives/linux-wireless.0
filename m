Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab2CBIel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 03:34:41 -0500
Subject: Re: [PATCH 08/21] cw1200: wsm.*, implementation of device
 high-level interface.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1330652495-25837-9-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024221_236578_27353535)
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
	 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
	 <1330652495-25837-9-git-send-email-dmitry.tarnyagin@stericsson.com>
	 (sfid-20120302_024221_236578_27353535)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 09:34:39 +0100
Message-ID: <1330677279.3367.8.camel@jlt3.sipsolutions.net> (sfid-20120302_093443_968746_218925D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 02:41 +0100, Dmitry Tarnyagin wrote:

> +/* ******************************************************************** */
> +/* Queue mapping: WSM <---> linux					*/
> +/* Linux: VO VI BE BK							*/
> +/* WSM:   BE BK VI VO							*/
> +
> +static inline u8 wsm_queue_id_to_linux(u8 queueId)
> +{
> +	static const u8 queue_mapping[] = {
> +		2, 3, 1, 0
> +	};
> +	return queue_mapping[queueId];
> +}

This could use the IEEE80211_AC_* defines I think.

johannes

