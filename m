Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46407 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1KVR5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 12:57:12 -0500
Received: by bke11 with SMTP id 11so519186bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 09:57:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321984379-1565-1-git-send-email-arik@wizery.com>
References: <1321984379-1565-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 22 Nov 2011 19:56:55 +0200
Message-ID: <CA+XVXfc2puMHpB-uFWJ1S3i=5ZqhBRfgpoGHJNjCmzPo4dipDA@mail.gmail.com> (sfid-20111122_185715_956050_15F8417D)
Subject: Re: [PATCH] wl12xx: avoid bail out when probe-resp is not set by mac80211
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 22, 2011 at 19:52, Arik Nemtsov <arik@wizery.com> wrote:
> During reconfig we can get the BSS_CHANGED_AP_PROBE_RESP indication
> even if a probe-resp has not been set in the first place. Therefore
> ignore the error when not getting a probe-resp from mac80211. Resort to
> the legacy probe-resp in this case.
>
> Also take this opportunity to add a vif argument to the set_probe_resp
> function.

Luca - This patch should be applied on top of the wl12xx probe
response patches (currently still not in your tree, but sent to the
list):

b07e95e wl12xx: indicate probe-resp offloading support
d804317 wl12xx: configure probe-resp template according to notification

Arik
