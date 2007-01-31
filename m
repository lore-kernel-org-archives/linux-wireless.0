Return-path: <wireless-bounces@tuxdriver.com>
Date: Wed, 31 Jan 2007 13:32:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [RFC] cfg80211 merge
Message-ID: <20070131183255.GB8776@tuxdriver.com>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131024807.GA7061@jm.kir.nu>
	<20070131182908.13bfc374@griffin.suse.cz>
Mime-Version: 1.0
In-Reply-To: <20070131182908.13bfc374@griffin.suse.cz>
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

On Wed, Jan 31, 2007 at 06:29:08PM +0100, Jiri Benc wrote:
> On Tue, 30 Jan 2007 18:48:07 -0800, Jouni Malinen wrote:
> > I'm all for getting this into the mainline kernel as soon as possible,
> > but I do not think that this should happen before there are user space
> > programs that demonstrate that cfg80211 can be used without problems and
> > that the kernel side implementation is complete enough to allow some
> > meaningful operations to be completed with cfg80211 (likely with WEXT
> > disabled, i.e., cfg80211 being feature complete for, say, WPA
> > authentication).
> 
> I fully agree with Jouni.

OK, where were you guys in London?  I don't recall any disagreement
there?

The WEXT compat code should be enough to drive the cfg80211 code.
And we would mark it CONFIG_EXPERIMENTAL (which I left out of the
patch) for now.  I suppose we could leave-out the nl80211 part to
avoid userland lock-in for now?

This also has the advantage of including the ieee80211_ptr in the
net_device structure, hopefully easing the task of packaging the rest
of the stack for external builds.

I suppose we could wait for at least one driver to be cfg80211-capable.
Would that satisfy everyone?

John
-- 
John W. Linville
linville@tuxdriver.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
