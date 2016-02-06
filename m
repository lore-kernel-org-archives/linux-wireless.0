Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53807 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcBFMCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 07:02:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v3,1/6] libertas: fix pointer bugs for PS_MODE commands
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1454173316-13444-2-git-send-email-andreas@kemnade.info>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com,
	Andreas Kemnade <andreas@kemnade.info>
Message-Id: <20160206120246.7F1066029F@smtp.codeaurora.org> (sfid-20160206_130302_561919_70E528C1)
Date: Sat,  6 Feb 2016 12:02:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> struct cmd_ds_802_11_ps_mode
> contains the command header and a pointer to it was
> initialized with data points to the body which leads to
> mis-interpretation of the cmd_ds_802_11_ps_mode.action member.
> cmd[0] contains the header, &cmd[1] points beyond that.
> cmdnode->cmdbuf is a pointer to the command buffer
> This piece of code was unused since power saving was
> not enabled.
> 
> Signed-off-by: Andreas Kemnade <andreas@kemnade.info>

Thanks, 6 patches applied to wireless-drivers-next.git:

0a7701b4defc libertas: fix pointer bugs for PS_MODE commands
fae4f9f78ab1 libertas: check whether bus can do more than polling
57954b94cad7 libertas: do not confirm sleep if commands are pending
fada24a54770 libertas: go back to ps mode without commands pending
0b8802dc5f59 libertas: fix ps-mode related removal problems
143e49458424 libertas: add an cfg80211 interface for powersaving

Kalle Valo
