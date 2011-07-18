Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45366 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1GRHV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 03:21:56 -0400
To: "Kahn\, Gery" <geryk@ti.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
	<874o2nx16b.fsf@purkki.adurom.net>
	<CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com>
	<CABB-i1eXpgA7iiHmrstFBnNjGntUtydQFBL17SJELqt5HU8g3A@mail.gmail.com>
	<87aaccvaxr.fsf@purkki.adurom.net> <8762n0ukdu.fsf@purkki.adurom.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 18 Jul 2011 10:21:55 +0300
In-Reply-To: <8762n0ukdu.fsf@purkki.adurom.net> (Kalle Valo's message of "Mon\, 18 Jul 2011 10\:18\:37 +0300")
Message-ID: <871uxouk8c.fsf@purkki.adurom.net> (sfid-20110718_092158_301935_97EE0217)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@adurom.com> writes:

> Kalle Valo <kvalo@adurom.com> writes:
>
>>> After some investigation, found that ethtool's ioctl interface doesn't work
>>> at this case.
>>
>> This reminds me: I have patches for these issues but I never sent them
>> upstream. It's too late for me now, but I'll search them tomorrow (or
>> today to be exact..) and send them for testing purposes.
>
> Here's the patch I used:

And patch to ethtool:

diff --git a/ethtool.c b/ethtool.c
index 4226a67..6e80926 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1363,12 +1363,15 @@ static int dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 		fclose(f);
 	}
 
-	if (!gregs_dump_hex)
+	if (!gregs_dump_hex) {
 		for (i = 0; i < ARRAY_SIZE(driver_list); i++)
 			if (!strncmp(driver_list[i].name, info->driver,
 				     ETHTOOL_BUSINFO_LEN))
 				return driver_list[i].func(info, regs);
 
+		fprintf(stdout, "version: 0x%x\n", regs->version);
+	}
+
 	fprintf(stdout, "Offset\tValues\n");
 	fprintf(stdout, "--------\t-----");
 	for (i = 0; i < regs->len; i++) {
