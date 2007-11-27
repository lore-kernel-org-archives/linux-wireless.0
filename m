Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:26165 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXK0H6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 02:58:24 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: Add debugfs hooks for configuring LED behavior.
Date: Tue, 27 Nov 2007 08:59:09 +0100
Cc: Andrey Yurovsky <andrey@cozybit.com>, olpc-devel@laptop.org,
	linville@tuxdriver.com
References: <474b4f06.0e578c0a.0e12.fffff5df@mx.google.com>
In-Reply-To: <474b4f06.0e578c0a.0e12.fffff5df@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711270859.09651.hs4233@mail.mn-solutions.de> (sfid-20071127_075828_906435_DFC79A41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 November 2007 23:56:06 Andrey Yurovsky wrote:
> +	The LED field specifies the LED number (1 or 2).  The Behavior field
> +	specifies what the LED should do: 0 for steady on, 1 for stead off, and

s/stead/steady/


> +	ctrl.numled = cpu_to_le16(0);

0 endian-converted stays 0.


> +	priv->leds_dir = debugfs_create_dir("leds",
> priv->debugfs_dir); +	if (!priv->leds_dir)

Where do you call debugfs_remove(priv->leds_dir) and
debugfs_remove(priv->leds_files[]) ?
