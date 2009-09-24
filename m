Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48559 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753100AbZIXVNI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 17:13:08 -0400
Message-ID: <4ABBE0E6.4090408@gmx.de>
Date: Thu, 24 Sep 2009 23:13:10 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
 wiphy
References: <20090924180048.14503.9579.stgit@tikku> <20090924180251.14503.64152.stgit@tikku>
In-Reply-To: <20090924180251.14503.64152.stgit@tikku>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2009 08:02 PM, Kalle Valo wrote:

> +	len = sizeof(wiphy->fw_version);
> +	snprintf(wiphy->fw_version, len, "%d.%d.%d-%d",
> +		 priv->fw_version.major, priv->fw_version.minor,
> +		 priv->fw_version.patch, priv->fw_version.build);
> +
> +	len = sizeof(wiphy->hw_version);
> +	snprintf(wiphy->hw_version, len, "%d", priv->board_type);
> +
> +	/* null terminate the strings in case they were truncated */
> +	wiphy->fw_version[len - 1] = '\0';
> +	wiphy->hw_version[len - 1] = '\0';

This only works as long as sizeof(wiphy->fw_version) == sizeof(wiphy->hw_version) - which is currently the case.
For sizeof(wiphy->fw_version) < sizeof(wiphy_hw_version) it overwrites memory behind wiphy->fw_version.

IMHO this is more robust against changes in the lengths of the char arrays:

+	wiphy->fw_version[sizeof(wiphy->fw_version) - 1] = '\0';
+	wiphy->hw_version[sizeof(wiphy->hw_version) - 1] = '\0';


Regards,
Jörg.
