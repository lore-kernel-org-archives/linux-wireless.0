Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:10944 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933022AbcLAMhe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 07:37:34 -0500
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Subject: mac802_hwsim: libnl does not detect genl hwsim protocol in default ns
To: <linux-wireless@vger.kernel.org>
Message-ID: <a97721a9-eea9-de7c-f1f9-2d9c32ff030b@uni-rostock.de> (sfid-20161201_133737_021369_4E697CD4)
Date: Thu, 1 Dec 2016 13:37:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I got a strange problem with newer kernel (post 4.8 stable) with hwsim.
Our current code works like this:

modprobe mac80211_hwsim radios=10

./costum_wmediumd

This will create all hwsim_interfaces in the first hwsim "netgroup"
within the default network namespace. But the code to lookup the genl
"MAC80211_HWSIM" protocol fails. Moreover some calls fails, other not ...

    //family = genl_ctrl_search_by_name(cache, "MAC80211_HWSIM"); -->
fails directly (return NULL)

    int hwsim_netlink_id = genl_ctrl_resolve(sock,"MAC80211_HWSIM");   
    if (hwsim_netlink_id == 0)
    {
        printf("Family MAC80211_HWSIM ID not found\n");
        exit(EXIT_FAILURE);
    }
    printf("Family ID found (%d), search for structure
\n\n",hwsim_netlink_id);
    family = genl_ctrl_search(cache, hwsim_netlink_id);
    if (family == NULL)
    {
        printf("Family MAC80211_HWSIM family not found\n");
        exit(EXIT_FAILURE);
    }

this will output:

"Family ID found (28), seatch for structure

Family MAC80211_HWSIM family not found"

But when I start the code in some network namespace, it works (but works
with no interfaces, as they stay in default network namespace). Of
course a workaround is easy, but it definitely breaks some legacy code,
working the same way. I reviewed the recent changes of hwsim regarding
namespaces, but I found no bug. The initial hwsim-devices are created in
netgroup 0 and the default namespace and I don't see any differentiation
of the netlink protocol registration, which depends on network
namespaces. Maybe there is a bug in libnl, but currently I have no Idea,
how to track down the issue.

Any suggestions ?
