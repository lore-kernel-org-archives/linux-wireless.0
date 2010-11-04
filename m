Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34955 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0KDOrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 10:47:53 -0400
Received: by qyk10 with SMTP id 10so1454058qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 07:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20101104T140201-178@post.gmane.org>
References: <loom.20101104T140201-178@post.gmane.org>
Date: Thu, 4 Nov 2010 10:47:52 -0400
Message-ID: <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com>
Subject: Re: Adding custom channels to ath5k for researching purposes
From: Bob Copeland <me@bobcopeland.com>
To: Vadim <Vadims.Kurmis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 9:03 AM, Vadim <Vadims.Kurmis@gmail.com> wrote:
> I need to enable 802.11p standard frequencies. How can I accomplish this? I
> found that CRDA is responsible for allowed channels.

Partially -- the channel list is exported by the driver but CRDA
adds additional regulatory restrictions.  The driver also imposes
certain regulatory restrictions based on the EEPROM data.

> So, where can I get binary
> frequency/channel database to use my hardware for researching purposes ?

You can create your own database, but you may need to modify the driver to
disregard the EEPROM settings, with the usual disclaimers: we won't support
it and if it breaks you get to keep both pieces.

Also note that ath5k only advertises a partial channel list; you can
get more via all_channels=1 modparam.  We don't do this by default
because they make scanning take forever and exceed channel list limits
in netlink.

-- 
Bob Copeland %% www.bobcopeland.com
