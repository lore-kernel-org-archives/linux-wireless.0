Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:60812 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYIZENa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 00:13:30 -0400
Received: by el-out-1112.google.com with SMTP id z25so179276ele.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 21:13:27 -0700 (PDT)
Message-ID: <43e72e890809252113h624a8d91jd859935ae5afed10@mail.gmail.com> (sfid-20080926_061334_216778_3ED1A00E)
Date: Thu, 25 Sep 2008 21:13:27 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <1222401242.2510.519.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
	 <1222401242.2510.519.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 8:54 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Thu, 2008-09-25 at 03:23 -0600, Johannes Berg wrote:
>> Not that I understand why you need that since iw shows all channels
>> you
>> are registering (albeit with possibly a few more flags like
>> "disabled"),
>> but yeah, if anything all this stuff should be in debugfs.
>
> The real user for the function is the automated test cases of our
> validation team running nightly. Greppig dmesg is not reliable and iw is
> not mature enough (at least not included in major distros). We will move
> it to debugfs for now. After iw is as common as iwconfig, we will
> eventually remove this.

What a distribution carries has no implications as to what you can
install on your own environment. We have both iw and crda installed in
our test environment, but that's also because we like to focus on
wireless-testing.

If you do development based on 2 previous releases essentially you
will get complaints on the type of patches you post based on this old
stuff.

>> There's also
>> this little fact that this channel list shouldn't ever get used, you
>> should be (and afaik are since I fixed it) using what the regdomain is
>> enforcing, and you're already printing the channel list when enough
>> debugging flags are set on driver load.
>
> This is used for debugging especially during the time regdomain is under
> development. I've received quite a few bug reports that is due to
> CONFIG_WIRELESS_OLD_REGULATORY is not enabled. I need at least a way to
> tell the users this is due to your misconfig your regdomain or your
> hardware is not capable to work on that channel.

CONFIG_WIRELESS_OLD_REGULATORY is a temporary solution, the right
solution for you is to build the regulatory domain with the provided
API as discussed at OLS. Additionally distributions can start picking
up iw and crda. I can also see NetworkManager asking the kernel to set
the regulatory domain just as with iw, based on the user's defined
country somewhere.

  Luis
