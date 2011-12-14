Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21298 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab1LNSpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 13:45:47 -0500
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4EE8EE80.8090008@qca.qualcomm.com> (sfid-20111214_194550_826014_A9CF79B7)
Date: Wed, 14 Dec 2011 20:44:16 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: support for P2P mgmt operations on station interface
References: <1323811932-5724-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1323811932-5724-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2011 11:32 PM, Aarthi Thiruvengadam wrote:
> This patch enables support for doing P2P management operations like device
> discovery on top of a station interface. After group formation, the station
> interface will become a P2P GO/client interface as the case may be.
> 
> This feature requires modifications to a couple of existing WMI structures and
> therefore new command ids and structures have been defined in order to be
> compatible with older firmware versions and other chips. The exception here is
> the wmi_connect_cmd. Adding a new field to the end of the structure will not
> cause any issues with previous firmware versions since firmware only checks for
> minimum length of the command. The other structures are of variable length,
> hence it was not possible to add new fields to the end. 
> 
> The new command ids have to be added to the end of enum wmi_cmd_id, so it has
> updated to match the firmware. 
> 
> The driver will support both the 'old' and the 'new' commands for a while by
> checking the firmware capabilities. 
> 
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

Thanks, applied.

Kalle
