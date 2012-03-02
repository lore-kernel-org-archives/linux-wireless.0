Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33643 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753621Ab2CBIlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 03:41:36 -0500
Message-ID: <1330677695.7070.2.camel@joe2Laptop> (sfid-20120302_094139_989810_7CACADBF)
Subject: Re: [PATCH 08/21] cw1200: wsm.*, implementation of device
 high-level interface.
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 02 Mar 2012 00:41:35 -0800
In-Reply-To: <1330677279.3367.8.camel@jlt3.sipsolutions.net>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
	 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
	 <1330652495-25837-9-git-send-email-dmitry.tarnyagin@stericsson.com>
	 (sfid-20120302_024221_236578_27353535) <1330677279.3367.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 09:34 +0100, Johannes Berg wrote:
> On Fri, 2012-03-02 at 02:41 +0100, Dmitry Tarnyagin wrote:
> > +/* ******************************************************************** */
> > +/* Queue mapping: WSM <---> linux					*/
> > +/* Linux: VO VI BE BK							*/
> > +/* WSM:   BE BK VI VO							*/
> > +
> > +static inline u8 wsm_queue_id_to_linux(u8 queueId)
> > +{
> > +	static const u8 queue_mapping[] = {
> > +		2, 3, 1, 0
> > +	};
> > +	return queue_mapping[queueId];
> > +}
> 
> This could use the IEEE80211_AC_* defines I think.

I suppose it could also range check or use an
enum for queueId.

