Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:49142 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753126AbZBHTrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 14:47:06 -0500
Message-ID: <498F36B7.40806@cosetrain.com> (sfid-20090208_204711_605640_93656C49)
Date: Sun, 08 Feb 2009 20:47:03 +0100
From: Florian Sesser <flomaillist@cosetrain.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Cc: Benedikt Elser <elser@in.tum.de>
Subject: [RFC/RFT v2] mac80211 / o11s mesh: Modularize Path Selection Protocol
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all!

Here is my second version of my abstraction modularizing the o80211s
mesh path selection protocol.

Sorry for taking so long, thanks for your comments!

I once again welcome your suggestions. Please have a look at my
mesh_path_selection_ops: Do you think they will suffice? It seems to me
that they do for mesh_hwmp, but I also might have overseen something
trivial here?

Where are the o11s guys BTW?

Changes from v1:

 * Incorporated suggestions from Rami and Johannes, especially:
   * checkpatch.pl (sorry 'bout that)
   * Moved two or so unnecessary comments to commit msgs
   * removed two unnecessary EXPORT_SYMBOLs
     (mesh_..._algo_find and mesh_..._algo_set)
   * removed mesh_..._find_by_name, use only find(u32 id)
     (that only breaks loading missing modules from disk,
     but that isn't really needed.)
   * keep mesh_hwmp built into mac80211, not as seperate module.
     registers itself on load.
   * wrote a Kconfig for my mesh_pptest skeleton module (although
     I don't think anybody wants this in vanilla?! I merely included
     it for reference...)

 * Renamed mesh_path_sel_algo_(un)register to
    ieee80211_mesh_path_sel_proto_(un)register

 * Moved mesh_path_timer/ieee80211_mesh_path_timer from mesh.c
   to mesh_pathtbl.c

 * Removed the typedefs for the function pointers in mesh_path_sel_ops
   and renamed them to avoid 'hungarian notation'

What I didn't do:

 * Change seven or so different calls via function pointers to
   static inlines. Johannes pointed me to rate_control, but the code
   there also isn't explicitly elegant IMHO - half a page of empty
   static inlines for the case of an algorithm being *not* used.
   Of course that gets compiled out, but the functions here aren't
   called very often, and in the case of HWMP, which heavily floods and
   by the draft standard is expected to work for mesh networks of up to
   32 nodes, the performance benefit is negligible IMHO. [The block
   device IO scheduler, where I took most of my inspiration from, also
   does not do that - and the functions there do get called a lot.]

What I don't know if I should do:

 * The names of the six extra EXPORT_SYMBOLS that are needed by mesh
   path selection algorithms (mainly form mesh_pathtbl.c and mesh.c)
   begin with mesh_ ... not ieee80211_... . Should I rename them?


Greetings!

Florian



