Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:33208 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752476AbdCAKiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 05:38:09 -0500
Received: by mail-qk0-f179.google.com with SMTP id n127so63087881qkf.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Mar 2017 02:37:28 -0800 (PST)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Gery Kahn <gery.kahn@broadcom.com>, Jouni Malinen <j@w1.fi>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: FILS offloading
To: Jouni Malinen <jouni@qca.qualcomm.com>
Message-ID: <d4fb8ca8-9632-3154-488e-5d7232601ed6@broadcom.com> (sfid-20170301_113922_671761_13E99A85)
Date: Wed, 1 Mar 2017 11:28:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hoi Jouni,

Not sure which email address to use ;-) I noticed a while ago that FILS
offloading was on the agenda of wireless workshop in Santa Fe. Recently,
looked at the FILS patches that were applied upstream and noticed:

static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
				    enum nl80211_auth_type auth_type,
				    enum nl80211_commands cmd)
{
	...
	switch (cmd) {
	...
	case NL80211_CMD_CONNECT:
	case NL80211_CMD_START_AP:
		/* SAE not supported yet */
		if (auth_type == NL80211_AUTHTYPE_SAE)
			return false;
		/* FILS not supported yet */
		if (auth_type == NL80211_AUTHTYPE_FILS_SK ||
		    auth_type == NL80211_AUTHTYPE_FILS_SK_PFS ||
		    auth_type == NL80211_AUTHTYPE_FILS_PK)
			return false;
		return true;
	default:
		return false;
	}
}

Are there any plans on QCA side to add FILS support for fullmac devices,
ie. supporting CONNECT command.

Regards,
Arend
