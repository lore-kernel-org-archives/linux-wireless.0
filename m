Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.cosetrain.com ([88.198.146.2]:60401 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbZLUP6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 10:58:50 -0500
Received: from localhost (mail.localhost [127.0.1.2])
	by mail.cosetrain.com (Postfix) with ESMTP id 487258EE5A
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 16:50:09 +0100 (CET)
Received: from mail.cosetrain.com ([88.198.146.2])
	by localhost (mail.cosetrain.com [127.0.1.2]) (amavisd-new, port 10024)
	with ESMTP id Xdi+sVUdZPaR for <linux-wireless@vger.kernel.org>;
	Mon, 21 Dec 2009 16:50:09 +0100 (CET)
Received: from [192.168.42.20] (ppp-93-104-97-24.dynamic.mnet-online.de [93.104.97.24])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.cosetrain.com (Postfix) with ESMTPSA id 099AC8EE56
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 16:50:08 +0100 (CET)
Message-ID: <4B2F9930.8070401@cosetrain.com>
Date: Mon, 21 Dec 2009 16:50:08 +0100
From: Florian Sesser <flomaillist@cosetrain.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: o11s: Modularize Path Selection Protocol etc.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi mesh folks!

For my diploma thesis, I want to add a P2P routing protocoll to the
pre-80211s software in the linux kernel. For details, see my previous
mails. [1],[2]

In struct ieee80211_if_mesh, the current code reads

net/mac80211/ieee80211_i.h
>         u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
>         size_t mesh_id_len;
>         /* Active Path Selection Protocol Identifier */
>         u8 mesh_pp_id;
>         /* Active Path Selection Metric Identifier */
>         u8 mesh_pm_id;
>         /* Congestion Control Mode Identifier */
>         u8 mesh_cc_id;
>         /* Synchronization Protocol Identifier */
>         u8 mesh_sp_id;
>         /* Authentication Protocol Identifier */
>         u8 mesh_auth_id;

which is what I at first wanted to work with.

In my last patch [2], I introduced some new 32 bit struct members,
because, if I am not mistaken, these IDs should include a vendor
specific OUI, which enables a user to combine a path selection protocol
of vendor A with a path selection metric of vendor B.

So.. am I erring here?

If yes, I would introduce a new 24 bit value for the OUI, which will be
combined with all the above u8's before going over the wire (into the
air of course)
...if no, I would replace those values by 32 bit ones, possibly even
braking ABI compatibility.

What do you think?
Do you maybe have a better suggestion?

Thank you very much for your input!


Florian

[1] http://marc.info/?l=linux-wireless&m=122600107811517&w=2
[2] http://marc.info/?l=linux-wireless&m=123300309207545&w=2


