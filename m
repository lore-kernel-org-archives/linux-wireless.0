Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub-lb1.unibe.ch ([130.92.0.82]:49420 "EHLO
	mailhub-lb1.unibe.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZBOVuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 16:50:22 -0500
Received: from localhost (scanhub-lb3.unibe.ch [130.92.5.67])
	by mailhub-lb1.unibe.ch (Postfix) with ESMTP id D84DD11C06E
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 22:42:18 +0100 (CET)
Received: from mailhub-lb1.unibe.ch ([130.92.0.82])
	by localhost (scanhub-lb3.unibe.ch [130.92.5.67]) (amavisd-new, port 10024)
	with LMTP id Mr9wkE8t1odY for <linux-wireless@vger.kernel.org>;
	Sun, 15 Feb 2009 22:42:18 +0100 (CET)
Received: from joker.unibe.ch (joker-eth0.unibe.ch [130.92.4.115])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhub-lb1.unibe.ch (Postfix) with ESMTP id 3C58211C088
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 22:42:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by joker.unibe.ch (Postfix) with ESMTP id 165C695607C
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 22:42:19 +0100 (CET)
Received: from joker.unibe.ch ([127.0.0.1])
	by localhost (joker.unibe.ch [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id zLdrX4Y+5iv1 for <linux-wireless@vger.kernel.org>;
	Sun, 15 Feb 2009 22:42:19 +0100 (CET)
Received: from localhost (nina [130.92.4.155])
	by joker.unibe.ch (Postfix) with ESMTP id DCF1A956062
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 22:42:18 +0100 (CET)
Message-ID: <20090215224218.da9seiz3s0ks40cg@mail.unibe.ch> (sfid-20090215_225028_097245_5535E25A)
Date: Sun, 15 Feb 2009 22:42:18 +0100
From: =?iso-8859-1?b?UOl0ZXV0?= Alain <alain.peteut@space.unibe.ch>
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2.6-old (15.02.2009)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I tried to find the solution, but I didn't found the root of the proble=
m:
for some reason ../drivers/net/wireless/iwl-4965.c wasn't compiled, but
the CONFIG_IWL4965=3Dy was defined config.mk.
This leads to a not existing struct iwl_cfg iwl4965_agn_cfg which was =20
claimed by make during making iwl4965.ko.

Since I don't need support for 4965 I set CONFIG_IWL4965=3Dn to overcom=
e =20
this issue.

I thought I'm fine but this leads to
=2E.
=46ATAL: Error inserting iwl4965 =20
(/lib/modules/2.6.26-1-amd64/kernel/drivers/net/wireless/iwlwifi/iwl496=
5.ko): =20
Unknown symbol in module, or unknown parameter (see dmesg)
=2E.
during make load.
Any suggestions?

Best regards
Alain P=E9teut


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
