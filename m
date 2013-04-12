Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:37371 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3DLPqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 11:46:25 -0400
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 802.11s mesh: dot11MeshMaxPeerLinks not working
Date: Fri, 12 Apr 2013 15:31:01 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C59F80@RockMX01.rock.corp> (sfid-20130412_174643_489795_85BDE233)
References: <CA+HVqbsEaGijdZ94sg2NH2hTgF=M_OB+gcXEDNB9KaeKQU6Uew@mail.gmail.com>
 <CAG6hwVN37OT8qHPmkH=YnY2JO68O+7DtBxpu6V4J0mWiGtxymw@mail.gmail.com>
 <CA+HVqbt6pu1--TYb5cij6H_iiz-2g3W4rK16S6+EjTWczL_tmw@mail.gmail.com>
 <CAEFj985vq6kDqWF1qQ4jER+ubm8f9HV0+kw-qYTncdyatoxZ=w@mail.gmail.com>
 <CA+HVqbvkSe=UuXLW9h0ziZL4_oBmnNOSfLFQnkuAcf4_th8ZoQ@mail.gmail.com>
 <CAEFj987Xcd7HuHfpqUzP8SGvxfRh0efHsgOMhiKWL8DTD-n1TQ@mail.gmail.com>  
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am running authsae + kernel 3.8.3. But I believe the behavior is the same on all kernel versions.

The dot11MeshMaxPeerLinks accepts value configured from user space (e.g. iw mesh0 set mesh_param)
But it does not take effect.

In the setup of 10 nodes, each one can see the rest. dot11MeshMaxPeerLinks is set to 4 in one node. However, this node still establishes 9 peers.

The 1st problem can be the estab_plinks counter itself. The /debugfs/ieee80211/phy0/netdev:mesh0/mesh_stats/estab_plinks shows 0. It does not match to the established 9 peer links.

Other problem can be timing issue. The mesh_plink_free_count() is checked on receiving peer-open peer-confirm packets. While mesh_plink_inc_estab_count() is called when peer is established. If all 9 peers issue peer-open at the same time to the UUT, mesh_plink_free_count() is good for all 9 peers since nobody is established yet. They all can establish link to UUT whose dot11MeshMaxPeerLinks is set to 4, though.
