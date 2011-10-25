Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64719 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1JYHQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 03:16:53 -0400
Message-ID: <4EA661F6.1000706@qca.qualcomm.com> (sfid-20111025_091657_193684_1E1641AB)
Date: Tue, 25 Oct 2011 10:15:02 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: Implement support for listen interval from
 userspace
References: <1319150111-5647-1-git-send-email-rpanjwan@qca.qualcomm.com> <1319150111-5647-2-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1319150111-5647-2-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2011 01:35 AM, Rishi Panjwani wrote:
> In order to allow user space based control of listen interval, we use
> available debugfs infrastructure. Listen interval implies how frequently
> we want the WLAN chip to wake up and synchronize the beacons in case it
> is in sleep mode. The feature has been added for testing purposes. The
> command requires two parameters in the following order:

An empty line here.

> 1) listen_interval_time
> 2) listen_interval_beacons
> 
> The user has to write the listen interval_time (in msecs) and
> listen_interval_beacons (in no. of beacons) to the listen_interval file in
> ath6kl debug directory.
> 
> Example:
> 
> echo "30 1" > listen_interval

[...]

> +	token = strsep(&sptr, " ");
> +	if (!token)
> +		return -EINVAL;
> +	if (kstrtou16(token, 0, &listen_int_t) ||
> +		kstrtou16(sptr, 0, &listen_int_b))
> +		return -EINVAL;

Just to improve readability separate these to two if clauses:

if (kstrtou16(token, 0, &listen_int_t))
	return -EINVAL;

if (kstrtou16(sptr, 0, &listen_int_b))
	return -EINVAL;

> +	if ((listen_int_t >= 15) && (listen_int_t <= 5000) &&
> +		(listen_int_b >= 1) && (listen_int_b <= 50)) {
> +		ar->listen_intvl_t = listen_int_t;
> +		ar->listen_intvl_b = listen_int_b;
> +		ath6kl_wmi_listeninterval_cmd(ar->wmi, ar->listen_intvl_t,
> +							ar->listen_intvl_b);
> +	} else {
> +		return -EINVAL;
> +	}

The style in kernel usually is that we handle the errors in the if
blocks and the normal code flow is without any indentation. Easier to
follow code path that way. So you could change this to:

if ((listen_int_t < 15) || (listen_int_t > 5000))
	return -EINVAL;

if ((listen_int_b < 1) > (listen_int_b > 50))
	return -EINVAL;

ar->listen_intvl_t = listen_int_t;
ar->listen_intvl_b = listen_int_b;

ath6kl_wmi_listeninterval_cmd(ar->wmi, ar->listen_intvl_t,
				ar->listen_intvl_b);

A lot easier to read that way.

Kalle
