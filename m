Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:53104 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758163AbYDVQTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 12:19:34 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: Roaming problems
Date: Tue, 22 Apr 2008 17:09:14 +0200
Message-ID: <00ff01c8a48a$d4063d80$0b3ca8c0@gotws1589> (sfid-20080422_182021_530520_6814A1A4)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0100_01C8A49B.978F0D80"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0100_01C8A49B.978F0D80
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, 

I'm currently running a number of sites using the RT61 WLAN chipset.
>From time to time we have fatal roaming problems. 

I have collected a trace that show normal and problem situation.
Any help explaining the cause of the problem is appreciated.

Below is a summary of the trace. Attached it the complete trace.

/Lars


CASE 1: The above trace is a typical trace from a roaming atempt.
==========================================================
361830.763657	We lost conatct with current AP 00:0e:d7:ac:84:20
361831.252992	We have selected the new AP 00:0f:24:d1:5e:e0
361831.256287	Why do we try to authenticate with previous AP
00:0e:d7:ac:84:20 ? <-----
361831.261071	Finaly we selected the correct AP 00:0f:24:d1:5e:e0
361831.295573	We are up and running

CASE 2: The above trace is a typical trace from a roaming atempt.
==========================================================
362123.346748	We lost conatct with current AP 00:0f:24:d1:5e:e0
362123.842242	We have selected the new AP 00:0e:d7:ac:84:20
362123.861586	We try connect AP 00:0e:d7:ac:84:20
362123.874442	We are up and running

CASE 3: The above trace is a typical trace from a roaming atempt.
===================================================================
362441.946825   We lost conatct with current AP 00:0e:d7:ac:84:20
362442.449435	We have selected the new AP 00:0f:24:a3:b8:60
362442.466944	Why do we try to authenticate with previous AP
00:0e:d7:ac:84:20 ? <-----
362442.470147	Finaly we selected the correct AP 00:0f:24:a3:b8:60
361831.295573	We are up and running
362443.066379	Timeout.
362444.886776	New try with selected AP 00:0f:24:a3:b8:60
362444.904429	Associated
362444.904883	What initiate this 'Initial auth_alg=0' with the associated
AP ? <-----
362444.908677	What initiate this 'Initial auth_alg=0' with AP
00:0f:24:d1:5e:e0 ? <-----
362445.505964	No one reacts on the 'timed out' event  <-----

------=_NextPart_000_0100_01C8A49B.978F0D80
Content-Type: text/plain;
	name="trace.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="trace.txt"

Hi,=20

I'm currently running a number of sites using the RT61 WLAN chipset.
>From time to time we have fatal roaming problems.=20

I have collected a trace that show normal and problem situation.
Any help explaning the cause of the problem is apprechiated.

/Lars


[361830.763657] wlan0: To few (3) beacons from current AP =
00:0e:d7:ac:84:20 - assume out of range
[361830.763726] phy0: Removed STA 00:0e:d7:ac:84:20
[361830.903691] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[361830.959483] HW CONFIG: channel=3D6 freq=3D2437 phymode=3D2
[361831.032651] HW CONFIG: channel=3D7 freq=3D2442 phymode=3D2
[361831.104153] HW CONFIG: channel=3D11 freq=3D2462 phymode=3D2
[361831.174702] HW CONFIG: channel=3D13 freq=3D2472 phymode=3D2
[361831.239425] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[361831.252992] wlan0: set_encrypt - unknown addr 00:0f:24:d1:5e:e0
[361831.253576] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[361831.256238] wlan0: Initial auth_alg=3D0
[361831.256287] wlan0: authenticate with AP 00:0e:d7:ac:84:20
[361831.258615] wlan0: RX authentication from 00:0e:d7:ac:84:20 (alg=3D0 =
transaction=3D2 status=3D0)
[361831.258662] wlan0: authenticated
[361831.258692] wlan0: associate with AP 00:0e:d7:ac:84:20
[361831.260485] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[361831.260544] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[361831.260586] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[361831.260628] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[361831.260670] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 4 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[361831.260712] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - =
CWmin: 5, CWmax: 10, Aifs: 2.
[361831.261031] wlan0: Initial auth_alg=3D0
[361831.261071] wlan0: authenticate with AP 00:0f:24:d1:5e:e0
[361831.282732] wlan0: RX authentication from 00:0f:24:d1:5e:e0 (alg=3D0 =
transaction=3D2 status=3D0)
[361831.282783] wlan0: authenticated
[361831.283546] wlan0: associate with AP 00:0f:24:d1:5e:e0
[361831.295124] wlan0: RX ReassocResp from 00:0f:24:d1:5e:e0 =
(capab=3D0x431 status=3D0 aid=3D95)
[361831.295221] wlan0: associated
[361831.295269] wlan0: CTS protection enabled =
(BSSID=3D00:0f:24:d1:5e:e0)
[361831.295573] phy0: Added STA 00:0f:24:d1:5e:e0
[361831.295628] wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D15 =
cWmax=3D1023 burst=3D0
[361831.295668] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - =
CWmin: 4, CWmax: 10, Aifs: 3.
[361831.295712] wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 =
cWmax=3D1023 burst=3D0
[361831.295749] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - =
CWmin: 4, CWmax: 10, Aifs: 7.
[361831.295792] wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 =
cWmax=3D15 burst=3D30
[361831.295829] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - =
CWmin: 3, CWmax: 4, Aifs: 2.
[361831.295872] wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 =
cWmax=3D7 burst=3D15
[361831.295908] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - =
CWmin: 2, CWmax: 3, Aifs: 2.

CASE 1: The above trace is a typical trace from a roaming atempt.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
361830.763657	We lost conatct with current AP 00:0e:d7:ac:84:20
361831.252992	We have selected the new AP 00:0f:24:d1:5e:e0
361831.256287	Why do we try to authenticate with previous AP =
00:0e:d7:ac:84:20 ? <-----
361831.261071	Finaly we selected the correct AP 00:0f:24:d1:5e:e0
361831.295573	We are up and running





[362123.346748] wlan0: To few (3) beacons from current AP =
00:0f:24:d1:5e:e0 - assume out of range
[362123.346815] phy0: Removed STA 00:0f:24:d1:5e:e0
[362123.480600] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[362123.539316] HW CONFIG: channel=3D6 freq=3D2437 phymode=3D2
[362123.611786] HW CONFIG: channel=3D7 freq=3D2442 phymode=3D2
[362123.683135] HW CONFIG: channel=3D11 freq=3D2462 phymode=3D2
[362123.746670] HW CONFIG: channel=3D13 freq=3D2472 phymode=3D2
[362123.822505] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[362123.842242] wlan0: set_encrypt - unknown addr 00:0e:d7:ac:84:20
[362123.852958] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[362123.853081] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362123.853128] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362123.853169] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362123.853211] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362123.853253] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 4 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362123.853295] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - =
CWmin: 5, CWmax: 10, Aifs: 2.
[362123.861530] wlan0: Initial auth_alg=3D0
[362123.861586] wlan0: authenticate with AP 00:0e:d7:ac:84:20
[362123.864873] wlan0: RX authentication from 00:0e:d7:ac:84:20 (alg=3D0 =
transaction=3D2 status=3D0)
[362123.864922] wlan0: authenticated
[362123.864952] wlan0: associate with AP 00:0e:d7:ac:84:20
[362123.874048] wlan0: RX ReassocResp from 00:0e:d7:ac:84:20 =
(capab=3D0x431 status=3D0 aid=3D181)
[362123.874097] wlan0: associated
[362123.874140] wlan0: CTS protection enabled =
(BSSID=3D00:0e:d7:ac:84:20)
[362123.874442] phy0: Added STA 00:0e:d7:ac:84:20
[362123.874497] wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D15 =
cWmax=3D1023 burst=3D0
[362123.883166] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - =
CWmin: 4, CWmax: 10, Aifs: 3.
[362123.883217] wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 =
cWmax=3D1023 burst=3D0
[362123.883255] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - =
CWmin: 4, CWmax: 10, Aifs: 7.
[362123.883298] wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 =
cWmax=3D15 burst=3D30
[362123.883335] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - =
CWmin: 3, CWmax: 4, Aifs: 2.
[362123.883376] wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 =
cWmax=3D7 burst=3D15
[362123.883413] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - =
CWmin: 2, CWmax: 3, Aifs: 2.

CASE 2: The above trace is a typical trace from a roaming atempt.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
362123.346748	We lost conatct with current AP 00:0f:24:d1:5e:e0
362123.842242	We have selected the new AP 00:0e:d7:ac:84:20
362123.861586	We try connect AP 00:0e:d7:ac:84:20
362123.874442	We are up and running





[362441.946825] wlan0: To few (0) beacons from current AP =
00:0e:d7:ac:84:20 - assume out of range
[362441.946894] phy0: Removed STA 00:0e:d7:ac:84:20
[362442.087032] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[362442.147484] HW CONFIG: channel=3D6 freq=3D2437 phymode=3D2
[362442.215884] HW CONFIG: channel=3D7 freq=3D2442 phymode=3D2
[362442.287306] HW CONFIG: channel=3D11 freq=3D2462 phymode=3D2
[362442.360678] HW CONFIG: channel=3D13 freq=3D2472 phymode=3D2
[362442.435708] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[362442.449435] wlan0: set_encrypt - unknown addr 00:0f:24:a3:b8:60
[362442.458892] HW CONFIG: channel=3D7 freq=3D2442 phymode=3D2
[362442.466891] wlan0: Initial auth_alg=3D0
[362442.466944] wlan0: authenticate with AP 00:0e:d7:ac:84:20
[362442.467815] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362442.467875] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362442.467917] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362442.467959] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362442.468000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 4 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362442.468043] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - =
CWmin: 5, CWmax: 10, Aifs: 2.
[362442.470093] wlan0: Initial auth_alg=3D0
[362442.470147] wlan0: authenticate with AP 00:0f:24:a3:b8:60
[362442.666716] wlan0: authenticate with AP 00:0f:24:a3:b8:60
[362442.869682] wlan0: authenticate with AP 00:0f:24:a3:b8:60
[362443.066379] wlan0: authentication with AP 00:0f:24:a3:b8:60 timed =
out
[362444.515475] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[362444.582299] HW CONFIG: channel=3D6 freq=3D2437 phymode=3D2
[362444.664275] HW CONFIG: channel=3D7 freq=3D2442 phymode=3D2
[362444.735721] HW CONFIG: channel=3D11 freq=3D2462 phymode=3D2
[362444.802200] HW CONFIG: channel=3D13 freq=3D2472 phymode=3D2
[362444.875930] HW CONFIG: channel=3D7 freq=3D2442 phymode=3D2
[362444.878856] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[362444.886723] wlan0: Initial auth_alg=3D0
[362444.886776] wlan0: authenticate with AP 00:0f:24:a3:b8:60
[362444.887643] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362444.887778] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362444.887821] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362444.887863] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362444.887904] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 4 - =
CWmin: 4, CWmax: 10, Aifs: 2.
[362444.887946] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - =
CWmin: 5, CWmax: 10, Aifs: 2.
[362444.896286] wlan0: RX authentication from 00:0f:24:a3:b8:60 (alg=3D0 =
transaction=3D2 status=3D0)
[362444.896340] wlan0: authenticated
[362444.896370] wlan0: associate with AP 00:0f:24:a3:b8:60
[362444.904391] wlan0: RX ReassocResp from 00:0f:24:a3:b8:60 =
(capab=3D0x431 status=3D0 aid=3D126)
[362444.904429] wlan0: associated
[362444.904662] phy0: Added STA 00:0f:24:a3:b8:60
[362444.904800] wlan0: Initial auth_alg=3D0
[362444.904838] wlan0: authenticate with AP 00:0f:24:a3:b8:60
[362444.908677] wlan0: Initial auth_alg=3D0
[362444.908735] wlan0: authenticate with AP 00:0f:24:d1:5e:e0
[362445.106501] wlan0: authenticate with AP 00:0f:24:d1:5e:e0
[362445.306037] wlan0: authenticate with AP 00:0f:24:d1:5e:e0
[362445.505964] wlan0: authentication with AP 00:0f:24:d1:5e:e0 timed =
out

CASE 3: The above trace is a typical trace from a roaming atempt.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
362441.946825   We lost conatct with current AP 00:0e:d7:ac:84:20
362442.449435	We have selected the new AP 00:0f:24:a3:b8:60
362442.466944	Why do we try to authenticate with previous AP =
00:0e:d7:ac:84:20 ? <-----
362442.470147	Finaly we selected the correct AP 00:0f:24:a3:b8:60
361831.295573	We are up and running
362443.066379	Timeout.
362444.886776	New try with selected AP 00:0f:24:a3:b8:60
362444.904429	Associated
362444.904883	What initiate this 'Initial auth_alg=3D0' with the =
associated AP ? <-----
362444.908677	What initiate this 'Initial auth_alg=3D0' with AP =
00:0f:24:d1:5e:e0 ? <-----
362445.505964	No one reacts on the 'timed out' event  <-----


>From this point, no WLAN communication was operating.



------=_NextPart_000_0100_01C8A49B.978F0D80--

