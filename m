Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab2K3MCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:02:22 -0500
Message-ID: <1354276964.10035.14.camel@jlt4.sipsolutions.net> (sfid-20121130_130225_630962_A84A41ED)
Subject: Re: [RFCv2 05/13] mac80211: track neighbor STA power modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 30 Nov 2012 13:02:44 +0100
In-Reply-To: <1353701934-12752-6-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-6-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:

> +/**
> + * ieee80211_has_qos_pm - check Power Save Level in QoS control
> + * @qc - QoS control bytes in little-endian byteorder
> + */
> +static inline bool ieee80211_has_qos_pm(__le16 qc)
> +{
> +	return (qc & cpu_to_le16(IEEE80211_QOS_CTL_MESH_PS_LEVEL)) != 0;

I think this is confusing. Why not call it "has_qos_mesh_ps" or
something?

johannes

