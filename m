Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:52291 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbZEZLG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 07:06:59 -0400
Received: by fxm12 with SMTP id 12so1939993fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 04:07:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090526110403.GA14626@sortiz.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	<1243307448-17441-2-git-send-email-yi.zhu@intel.com> <1243312991.21383.3.camel@localhost.localdomain>
	<1243317777.3623.19.camel@debian> <1243319583.30938.2.camel@localhost.localdomain>
	<1243320454.3623.35.camel@debian> <1243327894.30938.9.camel@localhost.localdomain>
	<20090526110403.GA14626@sortiz.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 26 May 2009 13:06:40 +0200
Message-ID: <ac3eb2510905260406v43f3fd71i6eceeec2ea6ecbf4@mail.gmail.com>
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 13:04, Samuel Ortiz <samuel.ortiz@intel.com> wrote:
> -       strlcpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
> +       fw_priv->fw_id = kzalloc(strlen(fw_name) + 1, GFP_KERNEL);

kstrdup()?

Kay
