Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:51712 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbXLEWL4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 17:11:56 -0500
Date: Wed, 5 Dec 2007 14:11:19 -0800
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] fixing the ap_scan and hidden SSID mess
Message-ID: <20071205221119.GA28457@bougret.hpl.hp.com> (sfid-20071205_221200_554569_4E95E9EB)
Reply-To: jt@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote :
> 
> Hidden SSID is a mess right now.  Here's why, and here's a proposal for
> fixing it.

	If you want my participation, it's usually wise to cc me.

> The problem is that there isn't a nice, generic capabilities field in
> WEXT.  So we have to abuse an existing one, and I picked enc_capa.

	Please don't do that. It's fairly trivial to add a new field
in iwrange. And it's not like the sky will fall down if we add a field
in iwrange. If you want to do it, please do it right.
	Note that there is one gotcha because of the state of
userspace, so if you want I can produce a kernel patch that will work
properly, and I'll add the usespace support for it as well.

> +#define IW_ENC_CAPA_SPECIFIC_SSID_SCAN	0x00000010

	That won't work. You have a tri-state, and with only a single
bit you can encode only two state. You basically have :
	o driver that support ap_scan=1
	o driver that do not support ap_scan=1
	o driver that have not been updated or reside in old kernels
	So, at the minimum, you'd want :
-------------------------------------
+#define IW_ENC_CAPA_SPECIFIC_SSID_SCAN	0x00000010
+#define IW_ENC_CAPA_ANY_SSID_SCAN	0x00000020
-------------------------------------

> However, userspace is f*cked because it can't figure out which one to
> use, and trying both is not an option because you get unacceptable
> latency for the user when trying to associate.

	Another option would be for SIOCSIWSCAN to fail if a specific
SSID is set and it does not support it, instead of just ignoring it.

	Regards,

	Jean
