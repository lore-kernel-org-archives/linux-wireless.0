Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36799 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdFYNEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 09:04:53 -0400
Date: Sun, 25 Jun 2017 14:04:37 +0100 (BST)
From: Sami Kerola <kerolasa@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Karel Zak <kzak@redhat.com>
cc: linux-wireless@vger.kernel.org, util-linux@vger.kernel.org
Subject: rfkill(8) move and improvements
Message-ID: <alpine.LNX.2.20.1706251339500.25762@imuri> (sfid-20170625_150517_301357_F56411D4)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello maintainers and other,

The otherday I ran powertop and it did rfkill to save battery, which was 
particularly annoying because I had not installed rfkill(8) package.  
Fixing the immediate issue was relatively easy, but the ordeal made me 
wonder if this tool could be moved to a package that is installed by 
default to all systems, such as util-linux.

To put money where my mouth is I have done the time consuming bits of the 
move.  Notice that full history of the rfkill project is saved in the git 
branch below, with attribution to original authors and no change to 
copyleft statement.

https://github.com/kerolasa/lelux-utiliteetit/tree/rfkill

But it would not be sufficient to do just the minimal, so I took liberty 
to make few additional changes. These include libsmartcols output, 
bash-completion file, add syslog message when state changes happen, and 
converting unix timestamps in event output to human readable format. 
Perhaps the easiest is to simply to see what I have done something like:

git clone https://github.com/kerolasa/lelux-utiliteetit.git rfkill-proposal
cd rfkill-proposal
./autogen.sh && ./configure && make -j4
git checkout rfkill
./rfkill
./rfkill --help
./rfkill event
man ./sys-utils/rfkill.8
. bash-completion/rfkill
PATH="$PWD:$PATH"
rfkill <tab tab>
git show origin/rfkill-master..origin/rfkill

What do you think, would the move and proposed updates be ok?

-- 
Sami Kerola
http://www.iki.fi/kerolasa/
