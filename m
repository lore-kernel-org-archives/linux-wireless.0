Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:45422 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2KFVn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 16:43:56 -0500
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id Ds2Aj82LRKwNg86p (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2012 16:43:53 -0500 (EST)
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: minor bug on these three macros for mesh
Date: Tue, 6 Nov 2012 21:43:52 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10A9E@RockMX01.rock.corp> (sfid-20121106_224407_698078_277A6C5C)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Net/mac80211/mesh_hwmp.c

#define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
#define disc_timeout_jiff(s) \
    msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
#define root_path_confirmation_jiffies(s) \
    msecs_to_jiffies(sdata->u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval)


The "sdata" in these 3 macros should be "s".
For now, code just happens to work since caller always passes in "sdata"

