Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62400 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2GZUMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 16:12:14 -0400
Received: by wgbdr13 with SMTP id dr13so2134617wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 13:12:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Lopez <jlopex@cozybit.com>
Subject: Re: [PATCH] carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces
Date: Thu, 26 Jul 2012 22:12:05 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1343332743-11845-1-git-send-email-jlopex@cozybit.com>
In-Reply-To: <1343332743-11845-1-git-send-email-jlopex@cozybit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201207262212.06227.chunkeey@googlemail.com> (sfid-20120726_221218_599826_5B02A593)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 July 2012 21:59:03 Javier Lopez wrote:
> This patch contains following modifications:
> 
> - Add mesh capabilities on fw.c to permit creation of mesh
>   interfaces using this driver.
> 
> - Modify carl9170_set_operating_mode, to use AP-style beaconing
>   with mesh interfaces.
> 
> - Allow beacon updates for NL80211_IFTYPE_MESH_POINT type in
>   carl9170_handle_command_response.
> 
> Signed-off-by: Javier Lopez <jlopex@cozybit.com>
Hm, what about virtual interfaces?

Do you think it's save to share a MESH node with
a STA, IBSS, AP interface on the same hardware?

Regards,
	Chr

On a side node: Can you tell me anything about
the crypto of mesh traffic? Because currently,
the code will disable any hardware crypto
offload for any mode other than STA and AP.
