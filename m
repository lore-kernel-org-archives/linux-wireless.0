Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19818 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243AbYCSTxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: convert RSSI to a direct command
Date: Wed, 19 Mar 2008 16:44:56 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803181342.42704.hs4233@mail.mn-solutions.de> <200803191614.16402.hs4233@mail.mn-solutions.de> <1205940431.4169.10.camel@localhost.localdomain>
In-Reply-To: <1205940431.4169.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803191644.57007.hs4233@mail.mn-solutions.de> (sfid-20080319_195443_641938_315FF76D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 1) We do need to fix the Ad-Hoc bits somehow, I guess that
> means periodically poking GET_RSSI when connected and
> averaging the result over the last 30 seconds, weighting
> recent results more

Okay for the periodically poking.

But we don't really need to average by ourselves, the GET_RSSI 
has an average weight parameter. We can store this in 
priv->avg_rssi and priv->avg_noise to re-use it later.


> 2) Use the windowed average for 'iwconfig'/SIOCGIWSTATS, the
> Ad-Hoc scan result, and scan results on the current channel

The patch as it is doesn't use any averaging 
for 'iwconfig'/SIOCGIWSTATS, it just uses the value from 
GET_RSSI, which is from the beacons of the associated AP. 
Together with the changed (simplified) quality calculation I now 
get a fast-enought changing display for a moving station. And 
it's no longer jerky as it used to be, despite the missing 
averaging. This non-jerkyness might come from the fact that RXPD 
packets aren't taken into account anymore. So I'm not sure if 
any averaging here will be an improvement, at least not for 
moving stations. It might be nicer for an office PC, thought.

I don't have a problem with priv->avg_noise for scan results and 
no problem at all what you want to do with AD HOC :-)


>
> 3) Use the default noise floor for all channels not the
> associated channel
>
> If you like, I'm interested in doing this.
>
> Dan


