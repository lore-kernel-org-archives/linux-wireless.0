Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab1KNXh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 18:37:26 -0500
Subject: Re: iwlagn 3.0.9 aggreggation messages
From: wwguy <wey-yi.w.guy@intel.com>
To: Lars Schotte <gusto@guttok.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111115003016.479f9a0f@hana.gusto>
References: <20111114131642.31e8ddbd@hana.gusto>
	 <1321283410.13578.33.camel@wwguy-ubuntu>
	 <20111114201947.58d5fdf6@hana.gusto>	<1321303101.1796.8.camel@wwguy-ubuntu>
	 <20111114221847.2ca32e6a@hana.gusto>
	 <1321305750.1796.11.camel@wwguy-ubuntu>
	 <20111114224718.491c1777@hana.gusto>
	 <1321307098.1796.14.camel@wwguy-ubuntu>
	 <20111114232852.2372a032@hana.gusto>
	 <1321310502.1796.21.camel@wwguy-ubuntu>
	 <20111114235636.24c85fc3@hana.gusto>
	 <1321311573.1796.35.camel@wwguy-ubuntu>
	 <20111115001621.0f89db2f@hana.gusto>
	 <1321312628.1796.37.camel@wwguy-ubuntu>
	 <20111115003016.479f9a0f@hana.gusto>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 15:31:11 -0800
Message-ID: <1321313471.1796.40.camel@wwguy-ubuntu> (sfid-20111115_003729_730022_C03F140A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-14 at 15:30 -0800, Lars Schotte wrote:
> kernel 3.1.0 and kernel 3.1.1 say this:
> 
> [   74.798240] iwlagn 0000:02:00.0: Tx aggregation enabled on ra =
> 20:4e:7f:5b:2d:f5 tid = 0 [  190.506907] iwlagn 0000:02:00.0: Tx
> aggregation enabled on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  242.249951]
> iwlagn 0000:02:00.0: Tx aggregation enabled on ra = 20:4e:7f:5b:2d:f5
> tid = 0 [  531.725659] iwlagn 0000:02:00.0: Tx aggregation enabled on
> ra = 20:4e:7f:5b:2d:f5 tid = 0 [  700.443255] iwlagn 0000:02:00.0: Tx
> aggregation enabled on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  794.438484]
> iwlagn 0000:02:00.0: Tx aggregation enabled on ra = 20:4e:7f:5b:2d:f5
> tid = 0 [ 1228.443709] iwlagn 0000:02:00.0: Tx aggregation enabled on
> ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 1427.104132] iwlagn 0000:02:00.0: Tx
> aggregation enabled on ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 1669.849989]
> iwlagn 0000:02:00.0: Tx aggregation enabled on ra = 20:4e:7f:5b:2d:f5
> tid = 0 [ 1846.380470] iwlagn 0000:02:00.0: Tx aggregation enabled on
> ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 1919.721844] iwlagn 0000:02:00.0: Tx
> aggregation enabled on ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 2042.692520]
> iwlagn 0000:02:00.0: Tx aggregation enabled on ra = 20:4e:7f:5b:2d:f5
> tid = 6 [ 2143.464146] iwlagn 0000:02:00.0: Tx aggregation enabled on
> ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 2157.828495] iwlagn 0000:02:00.0: Tx
> aggregation enabled on ra = 20:4e:7f:5b:2d:f5 tid = 0
> 
> that looks like a success, however the speed doesnt change, because the
> AP is set to only use HT20, so 1x20 MHz channel.

now you confuse me, it is a success? the problem is showing up, right?

Wey
> 
> On Mon, 14 Nov 2011 15:17:08 -0800
> wwguy <wey-yi.w.guy@intel.com> wrote:
> 
> > On Mon, 2011-11-14 at 15:16 -0800, Lars Schotte wrote:
> > > i looked over some changelogs .. from the linux kernel 3.1 branch.
> > > 
> > > i saw that you ve introduced some patches to this, or you at least
> > > signed them off.
> > > 
> > > the changelog also says that you've changed the logging level for
> > > that aggregation problem, so even if it would be there, it doesnt
> > > pop up on kernel 3.1's.
> > > 
> > > i also did read there that there was like waiting for a real reason
> > > to move to aggregation. so it was there the whole time, only it did
> > > not write itself out on the log.
> > > 
> > > so i am not sure if we were not just hunting ghosts here.
> > > 
> > you are correct, I do have patch to modify the log level and make sur
> > ewe are not generate the un-necessary messages in the log and cause
> > confusion. But I don't think it is related to what the behavior you
> > are seeing (at least I hope not); but I will double check. 
> > 
> > Thanks
> > Wey
> > 
> > > On Mon, 14 Nov 2011 14:59:33 -0800
> > > wwguy <wey-yi.w.guy@intel.com> wrote:
> > > 
> > > > ok, thanks
> > > > 
> > > > please do let us know if it appear on 3.1.1
> > > > 
> > > > at the meantime, we will look into how to backport to 3.0.x
> > > > 
> > > > Regards
> > > > Wey
> > > > 
> > > > On Mon, 2011-11-14 at 14:56 -0800, Lars Schotte wrote:
> > > > > i definitely see it in 3.0.8 and 3.0.9.
> > > > > 
> > > > > on the fedora fc16 linux kernel 3.1.1 it did not yet appear, but
> > > > > that may change.
> > > > > 
> > > > > so maybe it would be worth a look if it is not fixed by 3.1.1,
> > > > > or if something changed. however ... if it is a FIX, it should
> > > > > definitely be fixed also in 3.0.X branch.
> > > > > 
> > > > > so that message still is there on 3.0.9 and 3.0.8, we will see
> > > > > about the more current ones.
> > > > > 
> > > > > On Mon, 14 Nov 2011 14:41:42 -0800
> > > > > wwguy <wey-yi.w.guy@intel.com> wrote:
> > > > > 
> > > > > > so youno longer seeing the issue?
> > > > > > 
> > > > > > Wey
> > > > > 
> > > > > 
> > > > > 
> > > > 
> > > > 
> > > 
> > > 
> > > 
> > 
> > 
> 
> 
> 


