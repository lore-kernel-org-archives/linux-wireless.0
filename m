Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:51618 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYH2RXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 13:23:02 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7THN1P0031239
	for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 13:23:01 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7THN1JV193978
	for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 11:23:01 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7THN0tx004260
	for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 11:23:01 -0600
Subject: Re: [TESTING] Wireless mesh networking (802.11s) draft support
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	ltp-list <ltp-list@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@atheros.com
In-Reply-To: <20080828165618.GK4863@jm.kir.nu>
References: <1219698032.5434.6.camel@subratamodak.linux.ibm.com>
	 <20080825214625.GL6007@tesla>  <20080828165618.GK4863@jm.kir.nu>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 22:52:55 +0530
Message-Id: <1220030575.880.54.camel@subratamodak.linux.ibm.com> (sfid-20080829_192308_174885_C0420747)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Jouni and Luis,

On Thu, 2008-08-28 at 19:56 +0300, Jouni Malinen wrote:
> On Mon, Aug 25, 2008 at 02:46:25PM -0700, Luis R. Rodriguez wrote:
> 
> > Mesh code is GPLv2 right now. What I'd recommend is to get mesh support
> > added into mac80211_hwsim driver and then you can test mesh code without
> > even having any wireless hardware.
> 
> That would be quite useful addition for automated tests that anyone can
> run.

Yes, this is what we also aim to achieve - fully automated testing, even
if it requires some initial human intervention. Normally this happens
even in the normal LTP network tests:
http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/network,

Somebody needs to do the following:
1) Setup some network daemons to run on the server. This is done
manually,
2) The LTP source code should be installed at the same directory
location in both the client and the server,
3) From the Client side, the user-id/password/server-ip is exported,

Once this is done, then the network tests begin and then everything in
automated. You just need to analyze the logs after the test is over.

This typical scenario makes this test cases to run separately from other
default LTP tests, yet they reside inside LTP.

> 
> > At the third Linux wireless summit in Ottawa we briefly spoke about
> > automating testing for wireless. We should try to automate this first
> > with mac80211_hwsim and some scripts to do basic tests. Mesh testing can
> > be added once mac8021_hwsim gets support for Mesh.
> 
> I've started collecting test cases for mac80211_hwsim. It would be
> interesting to see whether these could be integrated into LTP somehow
> and allow people to run a set of tests in fully scripted way. These

Yes, this is the way we should target things. Say we have your wireless
test cases inside a directory:
http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/network/wireless/mesh_networking/

This should have some bare minimum entries, like:
1) Makefile -> which should be able to build any binary required and
also install the binaries (actual test cases and wrapper scripts, etc)
here:
http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/bin/
2) A master wrapper script which does:
 2.1) Checks out the existence of the driver(s) in the system,
      2.1.1) If does not exist, then the script should also be able to
download it from the required location,
 2.2) If driver exists, then load it,
      2.2.1) handle driver loading/unloading errors and report
accordingly,
 2.3) Then actually run those tests(other binaries/scripts) and record
results,
 2.4) Unload the driver once the tests are over ; report unloading
errors if any,

Starting initially, we will prevent your Makefile to get called from the
root LTP Makefile (when make is invoked from LTP root directory). This
allows only selected testers (who will be actually interested in testing
this component) to drill down to this sub-directory and issue make. And
then invoke the master wrapper script to run tests and see results. You
can look in to the following to see how SElinux tests are intergrated
inside LTP. This will help you to understand the scenario:
http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kernel/security/,

Once this process gets stabilized, we can integrate the make with the
LTP make so that your test cases gets built and installed during the
normal LTP build/install. Now in one of your READMEs, you should mention
the following things very properly:
1) Ways to get/download/install the source(test code),
2) Ways to build/install and run,
3) Any other special requirement/setup the tests need to execute, like
Glibc version ??, Kernel version ?? (which options in kernel should have
been enabled to get this feature running), Architecture Supported, etc.

I hope we can start in bits and pieces. You can create a small patch and
send it across. I am not in a hurry. Please take your time and do things
in bits and pieces. I wanted to stay in touch and make sure that we have
started to do somethings, however small they may be.

Regards--
Subrata

> tests are described in hostap.git tree mac80211_hwsim/tests
> subdirectories:
> http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim/tests
> 
> The current instructions for running the commands (*/test.txt) are more
> for a person than a script, but the changes to get test running would be
> trivial (i.e., just run hostapd and wpa_supplicant on background).
> Larger task is in adding some functionality to verify that the test
> passed and then finish with cleaning up (killing daemons from background
> and unload mac80211_hwsim).
> 

